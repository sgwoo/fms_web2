<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="cons_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	Vector vt = new Vector();
	vt = cons_db.getSManSearch("", s_kd, t_wd);
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(idx1, t_wd){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		fm.action="s_man.jsp?idx1="+idx1+"&t_wd="+t_wd;
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	
	function Disp2( title, nm, tel, m_tel){
		var fm = document.form1;
		opener.form1.call_t_nm.value 	= nm;
		opener.form1.call_t_tel.value 	= m_tel;
		if(m_tel == '' && tel !=''){	opener.form1.call_t_tel.value 	= tel;	}		
		window.close();
	}		
	

//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_man.jsp'>
  
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp; ����ȣ : 
           
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=whitetext onKeyDown="javasript:enter()" style='IME-MODE: active'>

        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">����</td>
                    <td class=title width="15%">����</td>
                    <td class=title width="20%">�μ�/����</td>
                    <td class=title width="15%">����</td>		  
                    <td class=title width="20%">����ó</td>
                    <td class=title width="20%">�ڵ���</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("GUBUN")%></td>
                    <td><%=ht.get("TITLE")%></td>		  
                    <td><a href="javascript:Disp2('<%=ht.get("TITLE")%>', '<%=ht.get("NM")%>', '<%=ht.get("TEL")%>', '<%=ht.get("M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
                    <td><%=ht.get("TEL")%></td>
                    <td><%=ht.get("M_TEL")%></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	

    <tr> 
        <td align="center">
	        <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	    </td>
    </tr>
</table>
</form>
</body>
</html>