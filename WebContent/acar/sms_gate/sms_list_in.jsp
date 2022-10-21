<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 		= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");	//발송대상
	String gubun2 		= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	//발송방식(집단,개별)
	//String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");	//분류구분
	String cc_id 		= request.getParameter("cc_id")==null?"":request.getParameter("cc_id");	//자동차회사
	String[] sido 		= request.getParameterValues("sido");		//지역(광역시,도)
	String[] gugun 		= request.getParameterValues("gugun");		//지역(기초구,군)
	String[] send_gubun = request.getParameterValues("send_gubun");		//발송구분	
	String commi_yn 	= request.getParameter("commi_yn")==null?"":request.getParameter("commi_yn");	//거래유무
	String cng_rsn 		= request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn"); 		//지정사유  
	
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm 		= request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");	
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort 		= request.getParameter("sort")==null?"":request.getParameter("sort");	
	String user_id 		= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	Vector empList = null;
	if(gubun1.equals("1") && gubun2.equals("1")){
		empList = umd.getCarOffEmpAll(cc_id, sido, gugun, send_gubun, commi_yn, cng_rsn, user_id);
	}else if(gubun1.equals("1") && gubun2.equals("2")){
		empList = umd.getCarOffEmpAll_20090702(gubun, gu_nm, sort_gubun, sort, send_gubun, commi_yn, cng_rsn, st_dt, end_dt);
	}else if(gubun1.equals("3")){
		//empList = umd.getEmpAll(gubun, gu_nm, sort_gubun, sort);
	}
	
	
	//명단수 합계
	int sum = 0;

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="javascript">
	function send_list(){
		fm = document.form1;
		//fm.target = parent.parent.i_no;
		fm.submit();		
	}
</script>
</head>

<body>
<form name="form1" action="./send_list.jsp" method="post">
<input name="sendname" type="hidden" value="">
<input name="sendphone" type="hidden" value="">
<input name="msg" type="hidden" value="">
<input name="req_dt" type="hidden" value="">
<input name="req_dt_h" type="hidden" value="">
<input name="req_dt_s" type="hidden" value="">
<input name="msg_type" type="hidden" value="0">
<input name="gubun1" type="hidden" value="">
<input name="gubun2" type="hidden" value="">
<table width="580" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line"><table width="100%" border="0" cellspacing="1" cellpadding="0">
          <%
	if(empList.size()>0){
		for(int i=0; i<empList.size(); i++){
			Hashtable ht = (Hashtable)empList.elementAt(i);
			String car_off_nm = (String)ht.get("CAR_OFF_NM");
			sum = i+1;
%>
          <tr>
            <td width="27"  align="center"><input name="pr" type="checkbox" value="<%= i %>" checked></td>
            <td width="27"  align="center"><%=i+1%></td>
            <td width="49"  align="center"><%= AddUtil.replace((String)ht.get("CAR_COMP_NM"),"자동차","") %></td>
            <td width="83" align="center"><span title="<%= ht.get("CAR_OFF_POST") %>"><%= ht.get("ADDR") %></span></td>
            <td width="73"  align="center"><span title="<%= car_off_nm %>">
              <%if(car_off_nm.indexOf("영업소")>0){
												out.print(AddUtil.subData(AddUtil.replace(car_off_nm,"영업소","(영)"),5));
											}else if(car_off_nm.indexOf("대리점")>0){
												out.print(AddUtil.subData(AddUtil.replace(car_off_nm,"대리점","(대)"),5));
											}else{
												out.print(AddUtil.subData(car_off_nm,5));
											}%>
              </span></td>
            <td width="55"  align="center"><input name="destname" type="text" class="white" size="8" readonly="true" value="<%= ht.get("EMP_NM") %>"></td>
            <td width="90"  align="center"><input name="destphone" type="text" class="white" size="13" readonly="true" value="<%= ht.get("EMP_M_TEL") %>"></td>
            <td width="55"  align="center"><%= ht.get("GUBUN") %></td>
            <td width="55"  align="center"><%= ht.get("CNG_RSN") %></td>			
            <td width="55"  align="center"><% if(AddUtil.parseInt((String)ht.get("COMMI_CNT"))>0) out.print("Y"); else out.print("N"); %></td>            
            <input name="excel_msg" type="hidden" value="">
          </tr>
          <% 		}
	}else{ %>
          <tr> 
            <td colspan="10"><div align="center">발송 대상자가 없습니다. </div></td>
          </tr>
          <% 	} %>
          <tr> 
            <td colspan="10" class="title">&nbsp;</td>
          </tr>
        </table></td>
  </tr>
</table>
</form>
</body>
</html>
<script language="javascript">
	parent.parent.form1.total.value = '<%= sum %>';	
</script>
