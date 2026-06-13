package com.shop.sportstore.untils;

import com.shop.sportstore.model.CartItem;
import com.shop.sportstore.model.Voucher;
import java.util.List;

public class VoucherValidator {

    public static class VoucherResult {
        public final boolean valid;
        public final String  message;
        public final long    discount;

        public VoucherResult(boolean valid, String message, long discount) {
            this.valid    = valid;
            this.message  = message;
            this.discount = discount;
        }
    }

    public static VoucherResult validate(Voucher voucher,
                                         List<CartItem> cart,
                                         long subtotal,
                                         String paymentMethod) {

        if (voucher == null) {
            return new VoucherResult(false, "Mã giảm giá không tồn tại hoặc đã hết hạn!", 0);
        }


        String vpm = voucher.getPaymentMethod();
        if (vpm != null && !vpm.equalsIgnoreCase("ALL") && !vpm.isEmpty()) {
            if (!vpm.equalsIgnoreCase(paymentMethod)) {
                return new VoucherResult(false,
                        "Mã này chỉ áp dụng khi thanh toán bằng " + vpm, 0);
            }
        }


        if (subtotal < (long) voucher.getMinOrderValue()) {
            long need = (long) voucher.getMinOrderValue() - subtotal;
            return new VoucherResult(false,
                    "Cần mua thêm " + String.format("%,d", need) + " VNĐ để dùng mã này", 0);
        }


        Integer catId = voucher.getCategoryId();
        if (catId != null && catId != 0) {
            boolean hasMatch = cart.stream()
                    .anyMatch(item -> item.getProduct().getCategoryId() == catId);
            if (!hasMatch) {
                return new VoucherResult(false,
                        "Mã này chỉ áp dụng cho sản phẩm thuộc danh mục nhất định", 0);
            }
        }

        // 4. Kiểm tra giá bán tối thiểu của sản phẩm trong giỏ
        double minPrice = voucher.getMinProductPrice();
        if (minPrice > 0) {
            boolean hasEligible = cart.stream()
                    .anyMatch(item -> item.getProduct().getPrice() >= minPrice);
            if (!hasEligible) {
                return new VoucherResult(false,
                        "Cần có sản phẩm giá từ " + String.format("%,.0f", minPrice) + " VNĐ trở lên", 0);
            }
        }

        // 5. Tính toán số tiền giảm (Discount)
        long discount;
        String desc;
        if ("PERCENT".equalsIgnoreCase(voucher.getDiscountType())) {
            discount = (long)(subtotal * voucher.getDiscountValue() / 100.0);

            // ĐÃ SỬA DÒNG 69: Dùng .longValue() thay cho ép kiểu nguyên thủy (long) sau khi check != null
            if (voucher.getMaxDiscount() != null && voucher.getMaxDiscount() > 0) {
                discount = Math.min(discount, voucher.getMaxDiscount().longValue());
            }

            desc = "Giảm " + (int) voucher.getDiscountValue() + "%";
        } else {
            discount = (long) voucher.getDiscountValue();
            desc = "Giảm " + String.format("%,.0f", voucher.getDiscountValue()) + " VNĐ";
        }

        discount = Math.min(discount, subtotal); // Số tiền giảm không vượt quá tổng tiền hàng
        return new VoucherResult(true, desc + " – Áp dụng thành công!", discount);
    }
}