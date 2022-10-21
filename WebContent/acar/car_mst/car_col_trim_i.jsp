<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.car_office.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_mst.CarColBean" scope="page"/>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="tr_bean" class="acar.car_mst.CarTrimBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");		
	
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	
	String use_yn 		= request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	
	CarMstBean [] cm_r = null;
	
	cm_r = a_cmd.getCarNmAll4(car_comp_id, code, t_wd, t_wd2, t_wd3, t_wd4, t_wd5, "Y", "1", "0");
	
	//색상관리 리스트	
	CarColBean [] co_r = a_cmd.getCarColListTrim(car_comp_id, code, "1", use_yn);
	
	//자동차회사 조회
	CarCompBean cc_r[] = umd.getCarCompAll(car_comp_id);
	cc_bean=cc_r[0];
	
	//차명 조회
		String car_cd = cmb.getCarNm(car_comp_id, code);
	
	//트림별 색상 조회
	CarTrimBean c_tr [] = a_cmd.getCarTrimCol(car_comp_id, code);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
font{
	font-size: 13px !important;
	font-weight: bold;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript">
//전체선택
function AllSelect(){
	var fm = document.form1;
	var len = fm.elements.length;
	var cnt = 0;
	var idnum ="";
	for(var i=0; i<len; i++){
		var ck = fm.elements[i];
		if(ck.checked == false){
			ck.checked = true;
		}else{
		}
	}
}

//전체해제
function AllReject(){
	var fm = document.form1;
	var len = fm.elements.length;
	var cnt = 0;
	var idnum ="";
	for(var i=0; i<len; i++){
		var ck = fm.elements[i];
		if(ck.checked == true){
			ck.checked = false;
		}else{
		}
	}
}

function CarColReg(){
	var fm = document.form1;
	var chk = "0";
	var len = fm.trim_chk.length;
	for(var i=0; i<len; i++){
		if(fm.trim_chk[i].checked == true)	chk++;
	}
	
	
	if(chk > 0){
		if(!confirm('반영하시겠습니까?')){	return;	}
		fm.target="i_no";
		//fm.target="_blank";
		fm.submit();
	}else{
		alert("1개 이상 체크해주세요");
		return;
	}
	
}
</script>

</head>
<body>
<form action="./car_col_trim_a.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
<input type="hidden" name="car_cd" value="<%=code%>">
	<table border=0 cellspacing=0 cellpadding=0 width="100%" class="search-area">
		<tr>
			<td>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td class="navigation">&nbsp;<span class=style1>MASTER>색상관리> <span class=style5>트림별외장색상관리</span>
						</span></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h></td>
		</tr>
		<tr>
	    	<td>
			    &nbsp;<label><i class="fa fa-check-circle"></i> 자동차 회사 : </label><%= cc_bean.getNm() %>
			    &nbsp; &nbsp;<label><i class="fa fa-check-circle"></i> 차명 : </label><%=car_cd%>
			 </td>
	    </tr>
		<tr>
			<td class=h></td>
		</tr>
	    <tr>
	        <td class=line2></td>
	    </tr>
		<tr>
			<td class=line>
				<table border="0" cellspacing="1" cellpadding="0" width="100%">
					<tr>
						<td width="35px" class=title>연번</td>
						<td width="230px" class=title>차종</td>
						<td width="80px" class=title>기준일자</td>
						<td width="85px" class=title>차량가격</td>
					<%for(int i=0; i<co_r.length; i++){
				    	 co_bean = co_r[i];%>
						<td class=title><%=co_bean.getCar_c()%></td>
					<%} %>
					</tr>
				<%for(int i=0; i<cm_r.length; i++){
				    	cm_bean = cm_r[i];
				%>
					<tr>
						<td class=title><%=i+1%></td>
						<td class=title style="text-align:left; padding : 4px 0 0 4px;"><%=cm_bean.getCar_name()%></td>
						<td align=center><%=AddUtil.ChangeDate2(cm_bean.getCar_b_dt())%></td>
						<td align=right><%=AddUtil.parseDecimal(cm_bean.getCar_b_p())%>원</td>
					<%for(int j=0; j<co_r.length; j++){
				     	co_bean = co_r[j];
				     	String car_col = cm_bean.getCar_id()+"^"+co_bean.getCar_u_seq()+"^"+co_bean.getCar_c_seq();%>
						<td align=center>
							<input 
								type="checkbox" 
								name="trim_chk" 
								value="<%=cm_bean.getCar_id()%>^<%=co_bean.getCar_u_seq()%>^<%=co_bean.getCar_c_seq()%>"
						<%for(int k=0; k<c_tr.length; k++){
				     			tr_bean =c_tr[k];
				     			String trim_col = tr_bean.getCar_id()+"^"+tr_bean.getCar_u_seq()+"^"+tr_bean.getCar_c_seq();
				     			String checked = "";
				     			
				     			if(car_col.equals(trim_col)) {%> checked<%} else {%><%} %>
				     	<%}%> 
				     		/>
						</td>
					<%} %>
					</tr>
					</tr>
				<%}%>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h></td>
		</tr>
		<tr>
			<td align="right">
				<input type="button" class="button" value="전체선택" onclick="javascript:AllSelect();">
				<input type="button" class="button" value="전체해제" onclick="javascript:AllReject();">
				<input type="button" class="button" value="반영" onclick="javascript:CarColReg();">
			</td>
		</tr>
	</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</body>
</html>