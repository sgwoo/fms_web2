<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.forfeit_mng.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");//�α���-������
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	
	
	
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//height
	int sh_height 	= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_ts.css">
</head>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
function search(){
	document.form1.submit();
}

function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}
</script>

<body>
<form name="form1" method="POST" action='fine_off_sc.jsp' target='c_foot'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ���·���� > <span class=style5>���¾�ü ���·����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                	<td class=title width=10%>�˻�����</td>
                    <td width=40%>&nbsp;
            		    <select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>���¾�ü</option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>������ȣ</option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>����</option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
        			    <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'  <%if(nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){%>readonly<%}%>>
        		    </td>
                    <td class=title width=10%>�Ⱓ</td>
                    <td width=40%>&nbsp;
            		    <select name='gubun1'>
                          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>������</option>
                          <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>���ο�û��</option>
                          <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>������</option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' size='11' name='st_dt' class='text' value=''>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="">
        		    </td>
                </tr>
        		<%-- <tr>
        		    <td class=title width=10%>����</td>
        		    <td colspan="3">&nbsp;
            		    <input type='radio' name="gubun2" value=''  <%if(gubun2.equals("")){%>checked<%}%>> ��ü
            		    <input type='radio' name="gubun2" value='1' <%if(gubun2.equals("1")){%>checked<%}%>>�Ƿ�
            		    <input type='radio' name="gubun2" value='2' <%if(gubun2.equals("2")){%>checked<%}%>>����
            		    <input type='radio' name="gubun2" value='3' <%if(gubun2.equals("3")){%>checked<%}%>>����
            		    <input type='radio' name="gubun2" value='4' <%if(gubun2.equals("4")){%>checked<%}%>>û��
            		    <input type='radio' name="gubun2" value='5' <%if(gubun2.equals("5")){%>checked<%}%>>Ȯ��
            		    <input type='radio' name="gubun2" value='6' <%if(gubun2.equals("6")){%>checked<%}%>>����
            		    <input type='radio' name="gubun2" value='8' <%if(gubun2.equals("8")){%>checked<%}%>>����
        		    </td>				  
        		</tr> --%>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a></td>
    </tr>    
</table>
</form>
</body>
</html>
