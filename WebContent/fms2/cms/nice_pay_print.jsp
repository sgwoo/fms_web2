<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
function reg_save(){
		var fm = document.form1;	
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='nice_pay_print_a.jsp';		
				fm.target='_self';
		fm.submit();		
		}		
	}		
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%

	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String adate 	= request.getParameter("adate")==null?"":request.getParameter("adate");

//	out.print(adate);
	
	//cms.member_user�� �������� ����Ÿ ��ȸ�ϱ�
	Vector vt = ai_db.getCardNicePayCmsList(s_kd, t_wd, adate);
	int vt_size = vt.size();
	
	int t_amt1=0;
	int t_amt2=0;
	int t_amt3=0;

   String r_chk = "";
			
	
%>
<form name='form1' method='post' >

<input type='hidden' name='sh_height' value='74'>
<input type='hidden' name=adate  value='<%=adate%>' > 
<input type='hidden' name=scd_size  value='<%=vt_size%>' > 

<table border="0" cellspacing="0" cellpadding="0" width=1270>
 <tr> 
 
 <%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
			   r_chk = String.valueOf(ht.get("RESULT"));
			   
          }
%>			
			
        <td align="left"> 
          <%	if ( r_chk.equals("0") ) {%> 
          <a href='javascript:reg_save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_save.gif" align="absmiddle" border="0"></a>
          <%    } %> 
        </td>
    </tr>
    
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		  <td width='40' class='title'>����</td>
		  <td width='120' class='title'>��ȣ</td>
		  <td width='100' class='title'>����ȣ</td>
		  <td width='100' class='title'>ġ����ȣ</td>
		  <td width='70' class='title'>��û��</td>
		  <td width='100' class='title'>��û�ݾ�</td>
		  <td width='100' class='title'>���ξ�</td>		
		  <td width='100' class='title'>������</td>		
		  <td width='100' class='title'>���ι�ȣ</td>	
		  <td width='80' class='title'>����</td>			  	
		  <td width='80' class='title'>ó��</td>
		  <td width='80' class='title'>�ڵ�</td>
		  <td width='200' class='title'>����޼���</td>
		 	
		 </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);		
			
			t_amt1 += AddUtil.parseInt(String.valueOf(ht.get("AMOUNT")));  
			t_amt2 += AddUtil.parseInt(String.valueOf(ht.get("R_AMOUNT")));  
			t_amt3 += AddUtil.parseInt(String.valueOf(ht.get("COMMISSION")));  
				
					
		%>
		<tr>
		  <td align="center" ><%=i+1%></td>
		  <td >&nbsp;<%=ht.get("CLIENT_NM")%></td>		  
		  <td align="center" >		  
		  <input type='hidden' name="user_no" value=<%=ht.get("USER_NO")%> ><%=ht.get("USER_NO")%></td>	
		  <td align="center" >	&nbsp;<%=ht.get("CAR_NO")%></td>		  	 
		  <td align="center" ><%=ht.get("ADATE")%></td>
		  <td align="right" >
		  <input type='text' name="amount" <% if( ht.get("RESULT").equals("0") ){%> <% } else { %> readonly <%} %> class=num   value='<%=Util.parseDecimal(String.valueOf(ht.get("AMOUNT")))%>'   size='10'    >
				  	 
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("R_AMOUNT")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("COMMISSION")))%></td>
		  <td align="center" ><%=ht.get("APPR_NO")%></td>		
		  <td align="center" >
		    <% if (ht.get("PROSS").equals("1") )  {%>��û <% } else if (ht.get("PROSS").equals("C") ) {%>��� <% } else if (ht.get("PROSS").equals("N") ) {%>���� <%}else{%>���� <%}%>
		   </td>
		  <td align="center" >
		  <% if (ht.get("RESULT").equals("0") )  {%>���� <% } else if (ht.get("RESULT").equals("1") ) {%>���� <% } else if (ht.get("RESULT").equals("Y") ) {%>���� <%}else{%>���� <%}%>
	      </td>		
		  <td align="center" ><%=ht.get("RESULT_CODE")%></td>
		  <td align="letf" ><%=ht.get("RESULT_INFO")%></td>		  	
		</tr>

<%}%>	
		 	<tr>
		  <td class=title align="center"  colspan=5>�հ�</td>
		  <td  class=title style="text-align:right" ><%=Util.parseDecimal(t_amt1)%></td>		 
		  <td  class=title style="text-align:right"><%=Util.parseDecimal(t_amt2)%></td>
		  <td  class=title style="text-align:right" ><%=Util.parseDecimal(t_amt3)%></td>
		  <td class=title align="center" ></td>		
		  <td class=title align="center"></td>
		  <td class=title align="center"></td>
		  <td class=title align="center"></td>
		  <td class=title align="center"></td>		  	
		</tr>
	  </table>
	</td>
  </tr>  
</table>
</form>
<script language='javascript'>
<!--

//-->
</script>
</body>
</html>