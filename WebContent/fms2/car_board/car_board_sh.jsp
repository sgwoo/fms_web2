<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus0401.*,  acar.car_register.*,  acar.cus_reg.*"%>
<%@ page import="acar.user_mng.*,  acar.insur.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	

	Cus0401_Database cusDb = Cus0401_Database.getInstance();
	Cus0401_carinfoBean carinfoBn = cusDb.getCarinfo(car_mng_id, l_cd);
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	CarInfoBean carinfoBn2 = cr_db.getCarInfo(car_mng_id);
	
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	InsDatabase ai_db = InsDatabase.getInstance();	
	
		//보험정보
	String ins_st = "";
	String ins_com_nm = "";
	
	//차량등록정보&보험
	if(!car_mng_id.equals("")){
		ins_st 	= ai_db.getInsSt(car_mng_id);
		ins 	= ai_db.getIns(car_mng_id, ins_st);
	}
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>

<input type='hidden' name='go_url' value='/fms2/car_board/car_board_frame.jsp'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>차량관리 > <span class=style5>게시판 </span></span></td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>	
     <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class="line">
                        <table cellspacing="1" cellpadding='0' border="0" width="100%">
                            <tr> 
                                <td class=title>차량번호</td>
                                <td>&nbsp;<a href="javascript:view_car('<%=car_mng_id%>')" onMouseOver="window.status=''; return true" title='자동차등록상세내역을 팝업합니다.'><b><%= carinfoBn.getCar_no() %></b></a></td>
                                <td class=title>차명</td>
                                <td colspan="5">&nbsp;<b><%= carinfoBn.getCar_jnm()+" "+carinfoBn.getCar_nm() %></b> </td>
                                <td class=title>최초등록일</td>
                                <td>&nbsp;<%= AddUtil.ChangeDate2(carinfoBn.getInit_reg_dt()) %></td>
                            </tr>
                            <tr> 
                              
                                <td class="title" width=7%>차종</td>
                                <td width=10%>
                                <%=c_db.getNameByIdCode("0041", "", carinfoBn.getCar_kd())%>
                                </td>
                                <td width=7% class=title>연식</td>
                                <td width=10%>&nbsp;<%= carinfoBn.getCar_y_form() %></td>
                                <td class=title>연료</td>
                                <td><b> 
                                  <%=c_db.getNameByIdCode("0039", "", carinfoBn.getFuel_kd())%>
                                  </b> </td>
                            
                                <td class=title>색상</td>
                                <td>&nbsp;<%= carinfoBn.getColo() %></td>
                                <td class=title>용도</td>
                                <td> <%if(carinfoBn.getCar_use().equals("1")){%>
                                  &nbsp;영업용 
                                  <%}else if(carinfoBn.getCar_use().equals("2")){%>
                                  &nbsp;자가용 
                                  <%}%> </td>
                            </tr>
							<tr> 
								<td class=title colspan="">검사유효기간</td>
								<td colspan="2" align='center'>&nbsp; 
								  <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(carinfoBn2.getMaint_st_dt())%>" size="10" class=whitetext>
								  ~ 
								  <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(carinfoBn2.getMaint_end_dt())%>" size="10" class=whitetext>
								  &nbsp; 
								</td>
								<td class=title>차령만료일</td>
								<td colspan="2">&nbsp; 
									<input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(cr_bean.getCar_end_dt()))%>" size="10" class=whitetext>
								</td>
								<td class=title colspan="">점검유효기간</td>
								<td colspan="3" align='center'>&nbsp; 
								  <input type="text" name="test_st_dt" value="<%=cr_bean.getTest_st_dt()%>" size="10" class=whitetext>
								  ~&nbsp; 
								  <input type="text" name="test_end_dt" value="<%=cr_bean.getTest_end_dt()%>" size="10" class=whitetext>
								</td>
							</tr>
                       
                        <tr> 
                                <td width="10%" class=title>보험회사</td>
                                <td width="12%">&nbsp;<a href="javascript:view_ins()"><%= carinfoBn.getIns_com_nm() %></a></td>
                                <td width="9%" class=title>보험기간</td>
                                <td colspan=3 >&nbsp;<%= AddUtil.ChangeDate2(carinfoBn.getIns_start_dt()) %> ~ <%= AddUtil.ChangeDate2(carinfoBn.getIns_exp_dt()) %></td>
                             	<td class=title>운전자연령</td>
                                <td colspan=3> <% if(carinfoBn.getAge_scp().equals("1")){ %>
                                  &nbsp;21세 이상 
                                  <% }else if(carinfoBn.getAge_scp().equals("2")){ %>
                                  &nbsp;26세 이상 
                                  <% }else if(carinfoBn.getAge_scp().equals("2")){ %>
                                  &nbsp;모든 운전자 
                                  <% } %> </td>
                            </tr>
                            <tr>                            
                                <td class=title>자기차량손해면책금</td>
                                <td >&nbsp;<%= AddUtil.parseDecimal(carinfoBn.getVins_cacdt_amt()) %>원</td>                          
                                <td class=title>피보험자</td>
                                <td colspan="2">&nbsp;<%if(ins.getCon_f_nm().equals("아마존카")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%> </td>
                                <td class=title>자기차량손해</td>
                                <td colspan="4">&nbsp;<%if(ins.getVins_cacdt_cm_amt()>0){%>
					<b><font color='#990000'>
가입 ( 차량 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>만원, 자기부담금 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>만원)
                    </font></b>
					<%}else{%>
                    -
                    <%}%></td>
                            </tr>							
                            <tr> 
                                <td class=title>특약사항</td>
                                <td colspan="9">
                                <%if(carinfoBn.getVins_spe().equals("")){%>
        										&nbsp;없음
        										<% }else{ %>
        										&nbsp;<%= carinfoBn.getVins_spe() %>
        										<% } %></td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
 
</table>
</form>
</body>
</html>
