<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd"); //update, inpsert 구분
	String nm_cd = request.getParameter("nm_cd")==null?"":request.getParameter("nm_cd");
	String nm = request.getParameter("nm")==null?"":request.getParameter("nm");
	String cd = request.getParameter("cd")==null?"":request.getParameter("cd");
	String etc = request.getParameter("etc")==null?"":request.getParameter("etc");
	String app_st = request.getParameter("app_st")==null?"":request.getParameter("app_st");
	String cms_bk = request.getParameter("cms_bk")==null?"":request.getParameter("cms_bk");
	String bigo = request.getParameter("bigo")==null?"":request.getParameter("bigo");
	int count = 0;

	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	if(cmd.equals("i")||cmd.equals("u"))
	{	
		cc_bean.setNm_cd	(nm_cd);
		cc_bean.setNm			(nm);
		cc_bean.setCode		(cd);
		cc_bean.setEtc		(etc);
		cc_bean.setApp_st	(app_st);
		cc_bean.setCms_bk	(cms_bk);
		cc_bean.setBigo		(bigo);
		
		CodeBean c_bean = c_db.getCodeBean("0001", cd, "");
		
		if(c_bean.getCode().equals("")){
			count = umd.insertCarComp(cc_bean);
		}else{
			count = umd.updateCarComp(cc_bean);
		}
		
		cmd = "";
	}
	
	CarCompBean cc_r [] = umd.getCarCompAll();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language="JavaScript">
<!--
	function CarCompReg(){
		var theForm = document.CarCompForm;
		if(!confirm('등록하시겠습니까?')){	return;	}
		theForm.cmd.value = "i";
		theForm.submit();
	}

	function CarCompUp(){
		var theForm = document.CarCompForm;
		var nm = theForm.nm.value;
		if(!confirm(nm + '을 수정하시겠습니까?')){	return;	}
		theForm.cmd.value = "u";
		theForm.submit();
	}

	function UpdateList(cd,nm_cd,nm,etc,app_st,cms_bk,bigo){
		var theForm = document.CarCompForm;
		theForm.nm_cd.value = nm_cd;
		theForm.nm.value= nm;
		theForm.cd.value= cd;		
		theForm.etc.value= etc;
		theForm.app_st.value= app_st;	
		if(cms_bk =='Y') 	theForm.cms_bk.checked= true;
		else							theForm.cms_bk.checked= false;
		theForm.bigo.value= bigo;
	}
//-->
</script>
</head>
<body leftmargin="15">

<form action="./car_comp_i.jsp" name="CarCompForm" method="POST" >
<input type="hidden" name="cd" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr >
		<td colspan=6 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>FMS운영관리 > MASTER >차종관리> <span class=style5>자동차회사관리</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan=6  class=h></td>
	</tr>
    <tr>
    	<td>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
            	<tr>
		    		<td width="45px" class="height_td"><label><i class="fa fa-check-circle"></i> 코드 </label></td>
		        	<td width="50px"><input type="text" name="nm_cd" value="" size="5" class=text class=input></td>
		    		<td width="85px" class="height_td"><label><i class="fa fa-check-circle"></i> 자동차 회사 </label></td>
		        	<td width="*"><input type="text" name="nm" value="" size="20" class=text class=input></td>
		        	<td></td>
		        </tr>
            	<tr>
		    		<td class="height_td"><label><i class="fa fa-check-circle"></i> 출처 </label></td>
		        	<td><select name="app_st" class="select" style="width:30px">
								<option value="1">국산</option>
								<option value="2">수입</option>
								<option value="3">기타</option>
							</select></td>		        	
		    		<td class="height_td"><label><i class="fa fa-check-circle"></i> 견적여부 </label></td>
		        	<td><input type="checkbox" name="cms_bk" value="Y"></td>
		        	<td></td>
		        </tr>
		        <tr>
		    		<td class="height_td"><label><i class="fa fa-check-circle"></i> 비고 </label></td>
		        <td colspan="4"><textarea name="etc" cols="90" rows="2" class=default style='IME-MODE: active'></textarea></td>
		    	</tr>
		        <tr>
		    		<td class="height_td"><label><i class="fa fa-check-circle"></i> 반영월</label></td>
		        <td colspan="4"><input type="text" name="bigo" value="" size="20" class=text class=input></td>
		    	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=right>
						<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
						  <a href="javascript:CarCompReg()" onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;
						<%}%>			
						<%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
						  <a href="javascript:CarCompUp()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
						<%}%>	
        </td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                	  <td class=title width=5%>코드</td>
                	  <td class=title width=5%>출처</td>
                    <td class=title width=15%>회사</td>
                    <td class=title width=50%>비고</td>
                    <td class=title width=15%>반영월</td>
                    <td class=title width=10%>견적여부</td>
                </tr>
				<%for(int i=0; i<cc_r.length; i++){
					cc_bean = cc_r[i];
					if(cc_bean.getNm().equals("에이전트")) continue;%>
				<tr>
					<td align=center><%= cc_bean.getNm_cd() %></td>
					<td align=center><%if(cc_bean.getApp_st().equals("1")){%>국산<%}else if(cc_bean.getApp_st().equals("2")){%>수입<%}else{%>기타<%}%></td>
          <td align=center><a href="javascript:UpdateList('<%= cc_bean.getCode() %>','<%= cc_bean.getNm_cd() %>','<%= cc_bean.getNm() %>','<%= cc_bean.getEtc() %>','<%= cc_bean.getApp_st() %>','<%= cc_bean.getCms_bk() %>','<%= cc_bean.getBigo() %>')"><%= cc_bean.getNm() %></a></td>
					<td align=center><textarea name="etc_c" rows=3 cols=80 style="overflow: hidden; border: 0;" readonly><%= cc_bean.getEtc() %></textarea></td>
					<td align=center><%= cc_bean.getBigo() %></td>
					<td align=center><%= cc_bean.getCms_bk() %></td>
                </tr>
				<%}%>                 
                
            </table>
        </td>
    </tr>
	<tr>
	  <td align="right"><a href="javascript:window.close()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
	</tr>
</table>
</form>
<script>
<%	if(cmd.equals("u")){%>

	alert("정상적으로 수정되었습니다.");

<%	}else{
		if(count==1){%>

	alert("정상적으로 등록되었습니다.");

<%		}
	}%>
</script>
</body>
</html>