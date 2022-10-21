<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode"); //영업/채권/비용/제안캠페인지급 
			
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int year =AddUtil.getDate2(1);
	
	String gubun = "";
	if ( mode.equals("12")) { gubun="2"; } //영업
 	if ( mode.equals("13")) { gubun="1"; } //채권
	if ( mode.equals("29")) { gubun="29"; }  //2군비용
	if ( mode.equals("30")) { gubun="30"; } //1군비용
	if ( mode.equals("26")) { gubun="6"; }  //제안 	
	
	int seq = 1;

%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st, s_type)
	{
		var fm = document.form1;
		var fm2 = document.form2;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		fm.mode.value 	= work_st;
		fm.s_type.value = s_type;	
	
		fm2.user_id.value = fm.user_id.value;
		fm2.s_year.value = fm.s_year.value;
		fm2.s_month.value = fm.s_month.value; 
		fm2.gubun.value = fm.gubun.value; 
		fm2.s_chk.value = fm.s_chk.value; 
		fm2.s_type.value = fm.s_type.value; 
		
		fm.<%=Webconst.Common.contentSeqName%>.value = '<%=AddUtil.ChangeString(AddUtil.getDate())+seq%>'+fm.s_year.value+fm.s_month.value+fm.s_chk.value+fm.gubun.value;
	
		if(!confirm('등록하시겠습니까?'))
		{
			return;
		}
		
		file_save();
		fm2.target = "i_no";
		fm2.action = 'set_end_popup_file_a.jsp';
		fm2.submit();
				
	}
	
function file_save(){
	var fm = document.form1;	
	fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact_t.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.STAT_CMP%>";
	fm.submit();
	
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>Master > <span class=style5>마감관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>  
	<tr>
	    <td class=line2></td>
	</tr>
	
<form action="" name='form1' method='post' enctype="multipart/form-data">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='s_type' value=''>
<input type='hidden' name='gubun' value='<%=gubun%>'>

    <tr>
	    <td class='line'>
    	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		<tr>
    		  <td width='22%' class='title'>등록 기준</td>
    		  <td>
                  &nbsp;<select name="s_year">
                    <%for(int i=2019; i<=year; i++){%>
                    <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                    <%}%>
                  </select>
              
                  <select name="s_month">
                     <option value="1" >1분기</option>
                     <option value="2" >2분기</option>
                     <option value="3" selected >3분기</option>
                     <option value="4" >4분기</option>
              
                  </select>
                  
                  <select name="s_chk">
                     <option value="3" >1군</option>
                     <option value="4" >2군</option>
                     <option value="5" selected >외근</option>
                     <option value="6" >내근</option>
              
                  </select>
                  
    		  </td>
    		</tr>
    		<tr> 
                    <td class='title' width="100">파일첨부</td>
                    <td colspan="2" >&nbsp; 
                      <input type="file" name="scan_file" size = "40">
                      <input type='hidden' name="<%=Webconst.Common.contentSeqName %>"  class='text' value='' />
					  <input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.STAT_CMP%>' />
					</td>
             </tr>
                
    	  </table>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  
  <tr>
	<td>
	<% if (mode.equals("12")) { %> 영업캠페인파일 <% } %>
	<% if (mode.equals("13")) { %> 채권캠페인파일 <% } %>
	<% if (mode.equals("25")) { %> 비용(1군-정비)캠페인파일 <% } %>
	<% if (mode.equals("28")) { %> 비용(1군-사고)캠페인파일 <% } %>
	<% if (mode.equals("29")) { %> 비용(2군)캠페인파일 <% } %>
	<% if (mode.equals("30")) { %> 비용(1군)캠페인파일 <% } %>
	<% if (mode.equals("26")) { %> 제안캠페인파일 <% } %>		
	<a href="javascript:save('<%=mode%>', '3')"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a></td>
  </tr>
  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>

</table>
</form>
<form action="" name="form2" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>">  
	<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  	
	<input type='hidden' name="user_id" value="">  	
	<input type='hidden' name="s_year" value=""> 
	<input type='hidden' name="s_month" value="">  
	<input type='hidden' name='mode' value=''>
    <input type='hidden' name='s_type' value=''>
    <input type='hidden' name='s_chk' value=''>
    <input type='hidden' name='gubun' value=''>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</body>
</html>
