<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<jsp:useBean id="fc_bean" class="acar.forfeit_mng.FineCallBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function UpdateList(car_mng_id,rent_mng_id,rent_l_cd,seq_no,fine_st,call_nm,tel,fax,vio_dt,vio_pla,vio_cont,paid_st,rec_dt,paid_end_dt,paid_amt,proxy_dt,pol_sta,paid_no,fault_st,dem_dt,coll_dt,rec_plan_dt,note){
		var theForm = parent.c_body.document.ForfeitForm; 
		theForm.car_mng_id.value = car_mng_id;
		theForm.rent_mng_id.value = rent_mng_id;
		theForm.rent_l_cd.value = rent_l_cd;
		theForm.seq_no.value = seq_no;
		theForm.fine_st.value = fine_st;
		theForm.call_nm.value = call_nm;
		theForm.tel.value = tel;
		theForm.fax.value = fax;
		theForm.vio_dt.value = vio_dt;
		theForm.vio_ymd.value = vio_dt.substring(0,8);
		theForm.vio_s.value = vio_dt.substring(8,10);
		theForm.vio_m.value = vio_dt.substring(10,12);
		theForm.vio_pla.value = vio_pla;
		theForm.vio_cont.value = vio_cont;
		theForm.paid_st.value = paid_st;
		theForm.rec_dt.value = rec_dt;
		theForm.paid_end_dt.value = paid_end_dt;
		theForm.paid_amt.value = paid_amt;
		theForm.proxy_dt.value = proxy_dt;
		theForm.pol_sta.value = pol_sta;
		theForm.paid_no.value = paid_no;
		theForm.fault_st.value = fault_st;
		theForm.dem_dt.value = dem_dt;
		theForm.coll_dt.value = coll_dt;
		theForm.rec_plan_dt.value = rec_plan_dt;
		theForm.cmd.value="up";
		theForm.note.value = note;
		//theForm.submit();
	}

	function FineCallReg(){
		var theForm1 = document.FineCallForm;
		var theForm2 = parent.c_body.document.ForfeitForm;
		theForm1.car_mng_id.value = theForm2.car_mng_id.value;
		theForm1.car_no.value = theForm2.car_no.value;
		theForm1.rent_mng_id.value = theForm2.rent_mng_id.value;
		theForm1.rent_l_cd.value = theForm2.rent_l_cd.value;
		theForm1.call_dt.value = theForm1.call_dt_yr.value + theForm1.call_dt_mth.value + theForm1.call_dt_day.value;		
		theForm1.target="nodisplay";
		theForm1.submit();
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String st = request.getParameter("st")==null?"2":request.getParameter("st");
	String f_st = request.getParameter("f_st")==null?"1":request.getParameter("f_st");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String call_dt = request.getParameter("call_dt")==null?"":request.getParameter("call_dt");
	String call_cont = request.getParameter("call_cont")==null?"":request.getParameter("call_cont");
	String reg_nm = request.getParameter("reg_nm")==null?"":request.getParameter("reg_nm");
	String call_dt_yr = "";
	String call_dt_mth = "";
	String call_dt_day = "";
	String user_id = "";
	String user_nm = "";
	
	LoginBean login = LoginBean.getInstance();
	user_id = login.getCookieValue(request, "acar_id");
	user_nm = login.getAcarName(user_id);
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	fc_bean = fdb.getFineCall(car_mng_id);
	car_no = fc_bean.getCar_no();
	call_dt = fc_bean.getCall_dt();
	call_dt_yr = fc_bean.getCall_dt_yr();
	call_dt_mth = fc_bean.getCall_dt_mth();
	call_dt_day = fc_bean.getCall_dt_day();
	call_cont = fc_bean.getCall_cont();
	reg_nm = user_nm;
%>
<table border="0" cellspacing="0" cellpadding="0" width=820>
	<tr>
        <td>
            <table border=0 cellspacing=1 width="820">
            	<tr>
            		<td align="left" width="801">< 위반리스트 ></td>
            		<td width=19>&nbsp;
					</td>
            	</tr>
            </table>
        </td>
    </tr>	
	<tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td><iframe src="./forfeit_i_sc_in.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&st=<%=st%>&f_st=<%=f_st%>&s_year=<%=s_year%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>" name="ForFeitList" width="800" height="150" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
			</table>
		</td>
	</tr>
	<form action="./fine_call_null_u.jsp" name="FineCallForm" method="post">
    <tr>
        <td >
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td valign="top">통화날짜 : </td>
            		<td valign="top">
            			<script language="JavaScript">init2(5,<%=call_dt_yr%>,<%=call_dt_mth%>,<%=call_dt_day%>); init_display4("call_dt");</script>
            			<input type="hidden" name="call_dt" value="<%=call_dt%>">
            		</td>
            		<td valign="top">통화내용 : </td>
            		<td><textarea name="call_cont" cols=70 rows=3><%=call_cont%></textarea></td>
            		<td>
<%	if(auth_rw.equals("R/W")){%>
            			<a href="javascript:FineCallReg()">통화등록</a>
<%	}%>
            		</td>            		
            	</tr>
		    </table>
		    <input type="hidden" name="reg_nm" value="<%=reg_nm%>">
		    <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
		    <input type="hidden" name="car_no" value="<%=car_no%>">
		    <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
		    <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
        </td>
    </tr>
</form>
</table>
</body>
</html>