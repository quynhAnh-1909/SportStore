<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="isEn" value="${sessionScope.lang == 'en'}" />

<jsp:include page="../client/header.jsp" />

<div style="max-width: 700px; margin: 50px auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 5px 25px rgba(0,0,0,0.1);">

    <!-- TITLE -->
    <h2 style="color: #004d31; border-bottom: 2px solid #004d31; padding-bottom: 15px; margin-bottom: 25px;">
        ${not empty match
            ? (isEn ? '⚙️ Edit Match' : '⚙️ Chỉnh Sửa Trận Đấu')
            : (isEn ? '➕ Add New Match' : '➕ Thêm Trận Đấu Mới')}
    </h2>

    <form action="${pageContext.request.contextPath}/admin/manager"
          method="post" enctype="multipart/form-data"  
          style="display: flex; flex-direction: column; gap: 20px;">

        <input type="hidden" name="matchId" value="${not empty match ? match.matchId : 0}">
        <input type="hidden" name="oldImageName" value="${match.opponentImageName}"> <!-- lấy dữ liệu từ match  ${match.opponentImageName}-->

        <!-- OPPONENT -->
        <div>
            <label style="display:block;font-weight:700;margin-bottom:8px;">
                ${isEn ? 'Opponent' : 'Đối thủ'}:
            </label>
            <input type="text" name="opponent" value="${match.opponent}" required
                   style="width:100%;padding:12px;border:1px solid #cbd5e0;border-radius:8px;box-sizing:border-box;">
        </div>

        <!-- DATE / TIME -->
        <div style="display:flex;gap:20px;">
            <div style="flex:1;">
                <label style="display:block;font-weight:700;margin-bottom:8px;">
                    ${isEn ? 'Match Date' : 'Ngày thi đấu'}:
                </label>
                <input type="date" name="matchDate" value="${match.matchDate}" required
                       style="width:100%;padding:12px;border:1px solid #cbd5e0;border-radius:8px;box-sizing:border-box;">
            </div>
            <div style="flex:1;">
                <label style="display:block;font-weight:700;margin-bottom:8px;">
                    ${isEn ? 'Match Time' : 'Giờ thi đấu'}:
                </label>
                <input type="time" name="matchTime" value="${match.matchTime}" required
                       style="width:100%;padding:12px;border:1px solid #cbd5e0;border-radius:8px;box-sizing:border-box;">
            </div>
        </div>

        <!-- STADIUM -->
        <div>
            <label style="display:block;font-weight:700;margin-bottom:8px;">
                ${isEn ? 'Stadium' : 'Sân Vận Động'}:
            </label>
            <select name="maSan" style="width:100%;padding:12px;border:1px solid #cbd5e0;border-radius:8px;">
                <option value="1" ${match.stadiumName != null && match.stadiumName.contains('Pleiku') ? 'selected' : ''}>
                    Pleiku
                </option>
                <option value="2" ${match.stadiumName != null && match.stadiumName.contains('Mỹ Đình') ? 'selected' : ''}>
                    Mỹ Đình
                </option>
            </select>
        </div>

        <!-- PRICE -->
        <div style="display:flex;gap:20px;">
            <div style="flex:1;">
                <label style="display:block;font-weight:700;margin-bottom:8px;">
                    ${isEn ? 'Min Price' : 'Giá thấp nhất'}:
                </label>
                <input type="number" name="minPrice" value="${match.minPrice}"
                       style="width:100%;padding:12px;border-radius:8px;">
            </div>
            <div style="flex:1;">
                <label style="display:block;font-weight:700;margin-bottom:8px;">
                    ${isEn ? 'Max Price' : 'Giá cao nhất'}:
                </label>
                <input type="number" name="maxPrice" value="${match.maxPrice}"
                       style="width:100%;padding:12px;border-radius:8px;">
            </div>
        </div>

        <!-- IMAGE -->
        <div>
            <label style="display:block;font-weight:700;margin-bottom:8px;">
                ${isEn ? 'Opponent Logo' : 'Logo đối thủ'}:
            </label>
            <input type="file" name="imageFile" accept="image/*"
                   style="width:100%;padding:10px;background:#f8fafc;border-radius:8px;">
        </div>

        <!-- ACTION -->
        <div style="display:flex;gap:15px;margin-top:20px;">
            <button type="submit"
                    style="flex:2;background:#004d31;color:white;border:none;padding:15px;border-radius:8px;font-weight:800;cursor:pointer;">
                ${not empty match
                    ? (isEn ? 'SAVE CHANGES' : 'LƯU THAY ĐỔI')
                    : (isEn ? 'CREATE MATCH' : 'TẠO TRẬN ĐẤU MỚI')}
            </button>

            <a href="${pageContext.request.contextPath}/matchList"
               style="flex:1;text-align:center;background:#edf2f7;color:#4a5568;text-decoration:none;padding:15px;border-radius:8px;">
                ${isEn ? 'CANCEL' : 'HỦY BỎ'}
            </a>
        </div>
    </form>
</div>

<jsp:include page="../client/footer.jsp" />
