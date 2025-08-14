<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<c:import url="/HTML/Admin/src/partials/title-meta.html" />
	<c:import url="/HTML/Admin/src/partials/head-css.html" />
    <link href="assets/vendor/flatpickr/flatpickr.min.css" rel="stylesheet" type="text/css" />
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>

<body>
<c:import url="/HTML/Admin/src/partials/html.html" />

	<h1>INDEX</h1>
    <!-- Begin page -->
    <div class="wrapper">

		<%@ include file="/HTML/Admin/src/partials/menu.html" %>
        <!-- ============================================================== -->
        <!-- Start Page Content here -->
        <!-- ============================================================== -->
        <div class="page-content">

            <div class="page-container">

                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header border-bottom justify-content-between d-flex flex-wrap align-items-center gap-2">
                                <div class="flex-shrink-0 d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <input type="text" class="form-control bg-light bg-opacity-50 border-0 ps-4" placeholder="Search Here...">
                                        <i
                                            class="ti ti-search position-absolute top-50 translate-middle-y start-0 ms-2"></i>
                                    </div>
                                </div>

                                <a href="apps-invoice-create.html" class="btn btn-primary"><i
                                    class="ti ti-plus me-1"></i>Add Invoice</a>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover text-nowrap mb-0">
                                    <thead class="bg-light-subtle">
                                        <tr>
                                            <th class="ps-3 py-1" style="width: 50px;">
                                                <input type="checkbox" class="form-check-input" id="customCheck1">
                                            </th>
                                            <th class="fs-12 text-uppercase text-muted py-1">Invoice ID</th>
                                            <th class="fs-12 text-uppercase text-muted py-1">Category </th>
                                            <th class="fs-12 text-uppercase text-muted py-1">Created On</th>
                                            <th class="fs-12 text-uppercase text-muted py-1">Invoice To</th>
                                            <th class="fs-12 text-uppercase text-muted py-1">Amount</th>
                                            <th class="fs-12 text-uppercase text-muted py-1">Due Date</th>
                                            <th class="fs-12 text-uppercase text-muted py-1">Status</th>
                                            <th class="text-center  py-1 fs-12 text-uppercase text-muted"
                                                style="width: 120px;">Action</th>
                                        </tr>
                                    </thead>
                                    <!-- end table-head -->

                                    <tbody>
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck2">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2026</a></span></td>
                                            <td>Fashion</td>
                                            <td><span class="text-muted">12 Apr 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-2.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">Raul Villa</h6>
                                                </div>
                                            </td>
                                            <td>$42,430</td>
                                            <td><span class="text-muted">12 Apr 2024</span></td>
                                            <td>
                                                <span class="badge bg-success-subtle text-success fs-12 p-1">Paid</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck3">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2025</a></span></td>
                                            <td>Electronics</td>
                                            <td><span class="text-muted">14 Apr 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-3.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">Fae Sims</h6>
                                                </div>
                                            </td>
                                            <td>$416</td>
                                            <td><span class="text-muted">24 Apr 2024</span></td>
                                            <td>
                                                <span
                                                    class="badge bg-warning-subtle text-warning fs-12 p-1">Overdue</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck4">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2024</a></span></td>
                                            <td>Mobile Accessories</td>
                                            <td><span class="text-muted">15 Apr 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-4.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">David Roderick</h6>
                                                </div>
                                            </td>
                                            <td>$187</td>
                                            <td><span class="text-muted">25 Apr 2024</span></td>
                                            <td>
                                                <span class="badge bg-success-subtle text-success fs-12 p-1">Paid</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck5">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2023</a></span></td>
                                            <td>Electronics</td>
                                            <td><span class="text-muted">6 Dec 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-5.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">James Zavel</h6>
                                                </div>
                                            </td>
                                            <td>$165</td>
                                            <td><span class="text-muted">14 Dec 2024</span></td>
                                            <td>
                                                <span class="badge bg-success-subtle text-success fs-12 p-1">Paid</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck6">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2022</a></span></td>
                                            <td>Electronics</td>
                                            <td><span class="text-muted">1 Jan 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-6.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">Denese Martin</h6>
                                                </div>
                                            </td>
                                            <td>$165</td>
                                            <td><span class="text-muted">14 Jan 2024</span></td>
                                            <td>
                                                <span
                                                    class="badge bg-danger-subtle text-danger fs-12 p-1">Cancelled</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck7">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2021</a></span></td>
                                            <td>Watches</td>
                                            <td><span class="text-muted">2 Dec 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-7.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">Jack Nunnally</h6>
                                                </div>
                                            </td>
                                            <td>$192</td>
                                            <td><span class="text-muted">2 Dec 2024</span></td>
                                            <td>
                                                <span
                                                    class="badge bg-warning-subtle text-warning fs-12 p-1">Overdue</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck8">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2020</a></span></td>
                                            <td>Bags</td>
                                            <td><span class="text-muted">12 May 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-8.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">Margaret Shaw</h6>
                                                </div>
                                            </td>
                                            <td>$159</td>
                                            <td><span class="text-muted">24 May 2024</span></td>
                                            <td>
                                                <span class="badge bg-success-subtle text-success fs-12 p-1">Paid</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck9">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2019</a></span></td>
                                            <td>Cloth's</td>
                                            <td><span class="text-muted">21 Jun 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-9.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">Anthony Williams</h6>
                                                </div>
                                            </td>
                                            <td>$259</td>
                                            <td><span class="text-muted">1 July 2024</span></td>
                                            <td>
                                                <span
                                                    class="badge bg-danger-subtle text-danger fs-12 p-1">Cancelled</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck10">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2018</a></span></td>
                                            <td>Sofa</td>
                                            <td><span class="text-muted">12 Aug 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-10.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">Axie Barnes</h6>
                                                </div>
                                            </td>
                                            <td>$259</td>
                                            <td><span class="text-muted">28 Aug 2024</span></td>
                                            <td>
                                                <span class="badge bg-success-subtle text-success fs-12 p-1">Paid</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                        <tr>
                                            <td class="ps-3">
                                                <input type="checkbox" class="form-check-input" id="customCheck11">
                                            </td>
                                            <td><span class="fw-semibold"><a href="apps-invoice-details.html" class="text-reset">#WA-2017</a></span></td>
                                            <td>Shoes</td>
                                            <td><span class="text-muted">8 Aug 2024</span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="avatar-sm">
                                                        <img src="assets/images/users/avatar-1.jpg" alt=""
                                                            class="img-fluid rounded-circle">
                                                    </div>
                                                    <h6 class="fs-14 mb-0">Glen Morning</h6>
                                                </div>
                                            </td>
                                            <td>$256</td>
                                            <td><span class="text-muted">30 Aug 2024</span></td>
                                            <td>
                                                <span
                                                    class="badge bg-warning-subtle text-warning fs-12 p-1">Pending</span>
                                            </td>
                                            <td class="pe-3">
                                                <div class="hstack gap-1 justify-content-end">
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-primary btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-eye"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-success btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-edit fs-16"></i></a>
                                                    <a href="javascript:void(0);"
                                                        class="btn btn-soft-danger btn-icon btn-sm rounded-circle"> <i
                                                            class="ti ti-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr><!-- end table-row -->
                                    </tbody><!-- end table-body -->
                                </table><!-- end table -->
                            </div>

                            <div class="card-footer">
                                <div class="d-flex justify-content-end">
                                    <ul class="pagination mb-0 justify-content-center">
                                        <li class="page-item disabled">
                                            <a href="#" class="page-link"><i class="ti ti-chevrons-left"></i></a>
                                        </li>
                                        <li class="page-item">
                                            <a href="#" class="page-link">1</a>
                                        </li>
                                        <li class="page-item active">
                                            <a href="#" class="page-link">2</a>
                                        </li>
                                        <li class="page-item">
                                            <a href="#" class="page-link">3</a>
                                        </li>
                                        <li class="page-item">
                                            <a href="#" class="page-link"><i class="ti ti-chevrons-right"></i></a>
                                        </li>
                                    </ul><!-- end pagination -->
                                </div><!-- end flex -->
                            </div>
                        </div> <!-- end card-->
                    </div> <!-- end col -->
                </div>

            </div> <!-- container -->

			<c:import url="/HTML/Admin/src/partials/footer.html" />
        </div>
        <!-- ============================================================== -->
        <!-- End Page content -->
        <!-- ============================================================== -->

    </div>
    <!-- END wrapper -->

	<c:import url="/HTML/Admin/src/partials/customizer.html" />
    <c:import url="/HTML/Admin/src/partials/footer-scripts.html" />


</body>
</html>