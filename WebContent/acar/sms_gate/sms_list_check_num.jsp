<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");	//발송대상
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	//발송방식(집단,개별)
	//String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	//분류구분
	String cc_id = request.getParameter("cc_id")==null?"":request.getParameter("cc_id");	//자동차회사
	String[] sido = request.getParameterValues("sido");		//지역(광역시,도)
	String[] gugun = request.getParameterValues("gugun");		//지역(기초구,군)
	String[] send_gubun = request.getParameterValues("send_gubun");		//발송구분	
	String commi_yn = request.getParameter("commi_yn")==null?"":request.getParameter("commi_yn");	//거래유무

	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");	
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");	
	String user_id = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");	
	String cng_rsn 		= request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Vector empList = null;
	if(gubun1.equals("1") && gubun2.equals("1")){
		empList = umd.checkEmpNum(cc_id, sido, gugun, send_gubun, commi_yn, user_id);
	}else if(gubun1.equals("1") && gubun2.equals("2")){
		empList = umd.checkEmpNum_20090702(gubun, gu_nm, sort_gubun, sort, commi_yn, cng_rsn, st_dt, end_dt);
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
//해당 영업사원 휴대폰번호 수정하기.
function update(idx, id){
	if(!confirm("해당 영업사원 데이터를 수정하시겠습니까?"))	return;
	fm = document.form2;
	fm.gubun.value = "u";
	fm.emp_id.value = id;
alert(form1.destphone[idx].value);	
	fm.emp_m_tel.value = form1.destphone[idx].value;
	fm.target = "i_no";
	fm.submit();
}
//해당 영업사원 소스(DB) 삭제하기.
function del_source(id){
	if(!confirm("해당 영업사원 데이터를 DB에서 삭제하시겠습니까?"))		return;
	fm = document.form2;
	fm.gubun.value = "ds";
	fm.emp_id.value = id;
	fm.target = "i_no";
	fm.submit();
}
//해당 영업사원 수신거부 하기=리스트에서 삭제하기
function del_list(id){
	if(!confirm("해당 영업사원 데이터를 발송명단 리스트에서 삭제하시겠습니까?"))		return;
	fm = document.form2;
	fm.gubun.value = "dl";
	fm.emp_id.value = id;
	fm.target = "i_no";
	fm.submit();
}

</script>
</head>

<body>
<form name="form2" method="post" action="car_off_emp_ud.jsp">
<input name="gubun" type="hidden" value="">
<input name="emp_id" type="hidden" value="">
<input name="emp_m_tel" type="hidden" value="">
</form>

<form name="form1" action="./send_list.jsp" method="post">
<input name="sendname" type="hidden" value="">
<input name="sendphone" type="hidden" value="">
<input name="msg" type="hidden" value="">
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	  <td><img src="/acar/images/center/arrow.gif" ><font color="#666666"><font color="#0066FF">수정</font>은 
        핸드폰번호를 수정하여 중복을 제거합니다.</font></td>
  </tr>
  <tr>
  	  <td><img src="/acar/images/center/arrow.gif" ><font color="#0066FF">삭제</font><font color="#666666">는 
        해당 영업사원을 데이터베이스에서 완전히 삭제를 합니다.</font></td>
  </tr>  
  <tr>
  	  <td><img src="/acar/images/center/arrow.gif" ><font color="#0066FF">제거</font><font color="#666666">는 
        해당 영업사원을 검색리스트에서 제거 합니다. 데이터베이스에는 남아있게 됩니다.</font></td>
  </tr>  
  <tr>
    <td class="line"><table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr><td class=line2></td></tr>
	  <tr>
		<td width="30" class="title">연번</td>
		<td width="70" class="title">소속사</td>
		<td width="100" class="title">근무지역</td>
		<td width="80" class="title">근무처</td>
		<td width="90" class="title">성명</td>
		<td width="100" class="title">휴대폰번호</td>
		<td width="55" class="title">거래유무</td>
		<td width="166" class="title">&nbsp;</td>
	  </tr>
	
<%
	if(empList.size()>0){
		for(int i=0; i<empList.size(); i++){
			Hashtable ht = (Hashtable)empList.elementAt(i);
			String car_off_nm = (String)ht.get("CAR_OFF_NM");
			sum = i+1;
%>
		<tr>
			<td width="30"  align="center"><%=i+1%></td>
			<td width="70"  align="center"><%= AddUtil.replace((String)ht.get("CAR_COMP_NM"),"자동차","") %></td>
			<td width="100" align="center"><span title="<%= ht.get("CAR_OFF_POST") %>"><%= ht.get("ADDR") %></span></td>
			<td width="80"  align="center"><span title="<%= car_off_nm %>"><%if(car_off_nm.indexOf("영업소")>0){
												out.print(AddUtil.subData(AddUtil.replace(car_off_nm,"영업소","(영)"),5));
											}else if(car_off_nm.indexOf("대리점")>0){
												out.print(AddUtil.subData(AddUtil.replace(car_off_nm,"대리점","(대)"),5));
											}else{
												out.print(AddUtil.subData(car_off_nm,5));
											}%></span></td>
			<td width="90"  align="center"><input name="destname" type="text" class="white" size="8" readonly="true" value="<%= ht.get("EMP_NM") %>"></td>
			<td width="100"  align="center"><input name="destphone" type="text" class="text" size="14"  value="<%= ht.get("EMP_M_TEL") %>"></td>
			<td width="55"  align="center"><% if(AddUtil.parseInt((String)ht.get("COMMI_CNT"))>0) out.print("Y"); else out.print("N"); %></td>
			<td width="166"  align="center"><a href="javascript:update('<%= i %>','<%= ht.get("EMP_ID") %>');"><img src="/acar/images/center/button_in_modify.gif"  border="0" align="absbottom"></a> | 
			<a href="javascript:del_source('<%= ht.get("EMP_ID") %>');"  title="원본삭제" ><img src="/acar/images/center/button_in_delete.gif"  border="0" align="absbottom"></a> | 
			<a href="javascript:del_list('<%= ht.get("EMP_ID") %>');" title="리스트에서제거"><img src="/acar/images/center/button_in_remove.gif"  border="0" align="absbottom"></a> </td>
		</tr>		
<% 		}
	}else{ %>
      <tr>
        <td colspan="8"><div align="center">번호 오류 대상자가 없습니다. </div></td>
        </tr>
<% 	} %>
      <tr>
        <td colspan="8" class="title">&nbsp;</td>
        </tr>
    </table></td>
  </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>

