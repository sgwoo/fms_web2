<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
  
	int year =AddUtil.getDate2(1);
	int mon =AddUtil.getDate2(2);
	
		
	int cnt = 3; //��Ȳ ��� �Ѽ�
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	//height
//	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
		

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

function Jungsan(){
		
		var fm = document.form1;
		var SUBWIN="card_jung_popup.jsp?user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value;	
		window.open(SUBWIN, "card_popup", "left=50, top=50, width=500, height=300, scrollbars=yes, status=yes");
		
}
		
function Search(){
		var fm = document.form1;
		//2016�� ���ĺ��� �˻����� 
		
		if ( toInt(fm.s_yy.value) < 2016 ) { 
		
			alert('2016�� ���ĺ��� ��ȸ�����մϴ�.!!!');
			return;
		}
		
		fm.action="jungsan_sc.jsp";			
		fm.target="cd_foot";		
		fm.submit();
}

function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
}

function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}	

//-->
</script>

</head>
<body>
<form  name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ���꼭 > <span class=style5>�����Ļ��� ���꼭</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
    <tr> 
      <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
           ���س⵵&nbsp;
           <select name="s_yy">
				<%for(int i=2020; i<=year; i++){%>
				<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>��</option>
				<%}%>
			</select> 			
			 &nbsp;
              <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
              ���ݱ� 
              <input type="radio" name="dt" value="5" <%if(dt.equals("5"))%>checked<%%>>
              �Ĺݱ� 
              <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
              ��ü 

			  &nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>	
    </tr>  
    <tr>
    <td>&nbsp;</td>
    </tr>
  </table>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>