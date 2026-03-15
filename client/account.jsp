<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="isEn" value="${sessionScope.lang == 'en'}"/>

<jsp:include page="header.jsp"/>

<div style="max-width: 1000px; margin: 40px auto; background: white;
            padding: 30px; border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);">

    <!-- TITLE -->
    <h2 style="color: #008f4c; border-bottom: 3px solid #008f4c;
               padding-bottom: 10px; margin-bottom: 25px;">
        ${isEn ? 'MY PROFILE' : 'HỒ SƠ CỦA TÔI'}
    </h2>

    <!-- USER INFO -->
    <div style="display:flex; gap:30px; background:#f8fbf9;
                padding:20px; border-radius:8px; margin-bottom:40px;">

        <div style="width:100px; height:100px; background:#008f4c;
                    border-radius:50%; display:flex;
                    align-items:center; justify-content:center;
                    color:white; font-size:3rem; font-weight:900;">
            ${sessionScope.user.fullName.substring(0,1).toUpperCase()}
        </div>

        <div>
            <h3 style="margin:0 0 10px 0;">
                ${sessionScope.user.fullName}
            </h3>

            <p style="margin:5px 0;">
                <strong>${isEn ? 'Email' : 'Email'}:</strong>
                ${sessionScope.user.email}
            </p>

            <p style="margin:5px 0;">
                <strong>${isEn ? 'Phone' : 'SĐT'}:</strong>
                ${sessionScope.user.phoneNumber}
            </p>
        </div>
    </div>

    <!-- HISTORY TITLE -->
    <h3 style="color:#2d3436; margin-bottom:20px;">
        ${isEn ? 'Successful Ticket Purchase History' : 'Lịch sử mua vé thành công'}
    </h3>

    <!-- TABLE -->
    <table style="width:100%; border-collapse:collapse;">
        <thead>
        <tr style="background:#008f4c; color:white;">
            <th style="padding:15px; text-align:left;">
                ${isEn ? 'Transaction ID' : 'Mã giao dịch'}
            </th>
            <th style="padding:15px; text-align:left;">
                ${isEn ? 'Match' : 'Trận đấu'}
            </th>
            <th style="padding:15px; text-align:left;">
                ${isEn ? 'Seat' : 'Vị trí ghế'}
            </th>
            <th style="padding:15px; text-align:left;">
                ${isEn ? 'Purchase Time' : 'Thời gian mua'}
            </th>
            <th style="padding:15px; text-align:right;">
                ${isEn ? 'Amount' : 'Số tiền'}
            </th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="ticket" items="${ticketList}">
            <tr style="border-bottom:1px solid #eee;">
                <td style="padding:15px;">#${ticket.orderId}</td>
                <td style="padding:15px; font-weight:bold;">
                    ${ticket.matchName}
                </td>
                <td style="padding:15px;">${ticket.seat}</td>
                <td style="padding:15px;">
                    <fmt:formatDate value="${ticket.paymentDate}"
                                    pattern="dd/MM/yyyy HH:mm"/>
                </td>
                <td style="padding:15px; text-align:right;
                           font-weight:bold; color:#e41e31;">
                    <fmt:formatNumber value="${ticket.amount}"
                                      type="currency"
                                      currencyCode="VND"
                                      maxFractionDigits="0"/>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty ticketList}">
            <tr>
                <td colspan="5"
                    style="padding:40px; text-align:center; color:#636e72;">
                    ${isEn
                        ? 'You have no ticket purchase history.'
                        : 'Bạn chưa có lịch sử mua vé nào.'}
                </td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<jsp:include page="footer.jsp"/>
