<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	BranchBean br_r [] = umd.getBranchAll();
%>
<%
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3"); //����
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4"); //��Ʈ
	String gubun5 = request.getParameter("gubun5")==null?"1":request.getParameter("gubun5"); //�Ϲݽ�
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page"); //	
	
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1"); //�Ⱓ
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2"); //
	
	String bm = request.getParameter("bm")==null?"1":request.getParameter("bm");//Ÿ��

%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchBrCond()
{
	var theForm = document.SearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin=15>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>���������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./stat_cls_sc.jsp" name="SearchForm" method="POST" target="c_foot">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
         <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
            	<tr>            		
            		<td width=6% class=title>������
            		</td>
            		<td colspan=5>&nbsp;<input type="text" name="ref_dt1" size="10" value="<%=ref_dt1%>" class=text> ~ <input type="text" name="ref_dt2" size="10" value="<%=ref_dt2%>" class=text>
					<a href="javascript:SearchBrCond()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
            	</tr>
            	
            	<tr>
                  <td width=6% class=title>��������</td>
                  <td width="30%">&nbsp;
        		    <select name='gubun3'>
                      <option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>��ü </option>
                      <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>���� </option>
                      <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>�縮�� </option>
                      <option value='9' <%if(gubun3.equals("9")){%>selected<%}%>>���� </option>
                    
                    </select>
        		  </td>
                  <td width="6%" class=title>�뵵����</td>
                  <td width="20%">&nbsp;
				  <select name='gubun4'>
                      <option value=''  <%if(gubun4.equals("")){ %>selected<%}%>>��ü </option>
                      <option value='1' <%if(gubun4.equals("1")){%>selected<%}%>>��Ʈ </option>
                      <option value='3' <%if(gubun4.equals("3")){%>selected<%}%>>���� </option>
                  </select></td>
                  <td width="6%" class=title>��������</td>
                  <td width="20%">&nbsp;
				  <select name='gubun5'>
                      <option value=''  <%if(gubun5.equals("")){ %>selected<%}%>>��ü </option>
                      <option value='1' <%if(gubun5.equals("1")){%>selected<%}%>>�Ϲݽ� </option>
                      <option value='3' <%if(gubun5.equals("3")){%>selected<%}%>>�⺻�� </option>
                  </select></td>
                </tr>                
                
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>