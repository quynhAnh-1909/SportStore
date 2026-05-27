<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>


<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Tài khoản cá nhân</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>

        body{

            background: #f5f6fa;

        }

        .profile-card{

            border: none;
            border-radius: 18px;
            background: white;
            box-shadow: 0 4px 18px rgba(0,0,0,0.05);
            overflow: hidden;

        }

        .profile-header{
            background: linear-gradient(135deg, #d81f19, #ff4d4f);
            padding: 35px;
            color: white;

        }

        .profile-header h2{
            font-weight: 700;
            margin: 0;

        }

        .profile-body{
            padding: 35px;
        }

        .avatar-wrapper{
            text-align: center;
        }

        .avatar{
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 50%;
            border: 5px solid #fff;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        .info-label{
            font-weight: 600;
            margin-bottom: 6px;
            color: #444;
        }

        .form-control{
            border-radius: 10px;
            padding: 10px 14px;
        }

        .form-control:focus{
            border-color: #d81f19;
            box-shadow: 0 0 0 0.15rem rgba(216,31,25,0.15);
        }

        .btn-save{
            background: #d81f19;
            border: none;
            border-radius: 10px;
            padding: 10px 25px;
            font-weight: 600;
            color: white;
            transition: 0.3s;
        }

        .btn-save:hover{
            background: #b31914;
        }
        .section-title{

            font-size: 22px;

            font-weight: 700;
            color: #d81f19;
        }
        .profile-info-box{
            background: #fafafa;
            border-radius: 14px;
            padding: 25px;
            height: 100%;

        }
        .divider{
            border-top: 1px solid #eee;
            margin: 35px 0;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/layout/index.jsp" />


<div class="container py-5">


    <div class="profile-card mb-5">


        <div class="profile-header d-flex justify-content-between align-items-center flex-wrap">

            <div>
                <h2>
                    <i class="fas fa-user-circle me-2"></i>
                    Tài khoản cá nhân
                </h2>

                <p class="mb-0 mt-2 opacity-75">
                    Quản lý thông tin tài khoản của bạn
                </p>
            </div>

        </div>


        <div class="profile-body">

            <div class="row g-4 align-items-center">


                <div class="col-lg-4">

                    <div class="profile-info-box avatar-wrapper">

                        <img src="${not empty user.avatar
                                ? user.avatar
                                : pageContext.request.contextPath.concat('/resources/default-avatar.png')}"
                             class="avatar"
                             alt="Avatar">

                        <h5 class="mt-3 fw-bold">
                            ${user.fullName}
                        </h5>

                        <p class="text-muted mb-0">
                            ${user.email}
                        </p>

                    </div>

                </div>

                <div class="col-lg-8">

                    <div class="profile-info-box">

                        <h4 class="section-title mb-4">
                            Thông tin cá nhân
                        </h4>

                        <form action="${pageContext.request.contextPath}/account"
                              method="post"
                              enctype="multipart/form-data">

                            <input type="hidden" name="action" value="editProfile">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="info-label">Họ và tên</label>
                                    <input type="text" name="fullName" value="${user.fullName}" class="form-control" required>
                                </div>

                                <div class="col-md-6 mb-3">

                                    <label class="info-label">
                                        Email
                                    </label>

                                    <input type="email"
                                           value="${user.email}"
                                           class="form-control"
                                           disabled>

                                    <small class="text-muted">
                                        Email không thể thay đổi
                                    </small>

                                </div>

                            </div>


                            <div class="mb-3">

                                <label class="info-label">
                                    Số điện thoại
                                </label>

                                <input type="text"
                                       name="phone"
                                       value="${user.phoneNumber}"
                                       class="form-control">

                            </div>


                            <div class="mb-4">

                                <label class="info-label">
                                    Ảnh đại diện
                                </label>

                                <input type="file"
                                       name="avatar"
                                       class="form-control">

                            </div>


                            <button type="submit"
                                    class="btn-save">

                                <i class="fas fa-save me-2"></i>
                                Lưu thay đổi

                            </button>

                        </form>

                    </div>

                </div>

            </div>

        </div>

    </div>


    <div class="divider"></div>

    <jsp:include page="/WEB-INF/client/order-history.jsp" />

</div>

<jsp:include page="/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>