<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.admin.*" %>	
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�ڵ������� �˻� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	

	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector vt = ad_db.getMasterCarComAcarExcelList(s_kd, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}
	

//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="3500">
 <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='12%' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%' height=71>       
          <tr> 
        	<td class="title" width='12%'>����</td>
			<td class="title" width='10%'>����</td>	  
			<td class="title" width='16%'>�������</td>	  	  
			<td class="title" width='20%'>������ȣ</td>
			<td class="title" width='42%'>����</td>
          </tr>
      </table>
	</td>
	<td class='line' width='88%'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%' height=71>    
		<tr>
		  <td class="title" width='3%'>������</td>
		  <td class="title" width='2%'>����</td>			
		  <td class="title" width='2%'>�̼�</td>				  
		  <td class="title" width='4%'>����</td>
		  <td class="title" width='6%'>��</td>
		  <td class="title" width='4%'>�繫��</td>
		  <td class="title" width='4%'>�޴���</td>			 		
		  <td class="title" width='14%'>�ּ�</td>
		   <td class="title" width='4%'>�ǿ�����</td>		
	<!--	  <td class="title" width='5%'>�̸���</td> -->
		  <td class="title" width='3%' >�����</td>
		  <td class="title" width='4%'>�뿩�Ⱓ</td>			
		  <td class="title" width='5%'>���ι��</td>
		  <td class="title" width='3%'>���ι��</td>
		  <td class="title" width='3%'>�빰���</td>
		  <td class="title" width='3%'>�ڱ��ü���<br>_������</td>			
		  <td class="title" width='3%'>�ڱ��ü���<br>_�λ�</td>
		  <td class="title" width='3%'>��������</td>
		  <td class="title" width='3%'>�����ڱ�δ��</td>
		  <td class="title" width='2%'>������</td>			
		  <td class="title" width='2%'>��������</td>
		  <td class="title" width='3%'>���ɹ���</td>			
		  <td class="title" width='2%'>�����</td>
		  <td class="title" width='4%'>�Ǻ�����</td>
		  <td class="title" width='2%'>����<br>�����</td>		
		  <td class="title" width='2%'>�������</td>		
		  <td class="title" width='2%'>�뿩���</td>			
		  <td class="title" width='2%'>����<br>�����</td>			
		  <td class="title" width='3%'>����ó</td>	
		  <td class="title" width='2%'>�˻��Ƿ�</td>			  	  	  	  	     
		</tr>
	  </table>
	</td>
  </tr>

 <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='12%' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
        <tr > 
         <td align="center" width='12%'><%=i+1%></td>
		  <td align="center" width='10%'><%=ht.get("����")%></td>	  
		  <td align="center" width='16%'><%=ht.get("�������")%></td>	  	  
		  <td align="center" width='20%'><%=ht.get("������ȣ")%></td>
		  <td align="center" width='42%'>
		  <span title='<%=ht.get("����")%>'><%=Util.subData(String.valueOf(ht.get("����")),10)%></span></td>
		 
        </tr>      
        <%		}	%>
       	
      </table>
	</td>
	<td class='line' width='88%'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr>
		  <td align="center"	width='3%'><%=ht.get("������")%></td>
		  <td align="center"	width='2%'><%=ht.get("����")%></td>
		  <td align="center"	width='2%'><%=ht.get("�̼�")%></td>	  
		  <td align="center"	width='4%'><%=ht.get("����")%></td>
		  <td align="center"	width='6%'>
		   <span title='<%=ht.get("��")%>'><%=Util.subData(String.valueOf(ht.get("��")),14)%></span></td>
		  <td align="center"	width='4%'><%=ht.get("�繫��")%></td>
		  <td align="center"	width='4%'><%=ht.get("�޴���")%></td>				  
		  <td align="center"	width='14%'>
		   <span title='<%=ht.get("�ּ�")%>'><%=Util.subData(String.valueOf(ht.get("�ּ�")),30)%></span></td>	
		  <td align="center"	width='4%'><%=ht.get("�ǿ�����")%></td>	
	<!--	  <td align="center"	width='5%'><%=ht.get("�̸���")%></td> -->
		  <td align="center"	width='3%'><%=ht.get("�����")%></td>
		  <td align="center"	width='4%'><%=ht.get("�뿩�Ⱓ")%></td>
		  <td align="center"	width='5%'><%=ht.get("���ι��")%></td>
		  <td align="center"	width='3%'><%=ht.get("���ι��")%></td>
		  <td align="center"	width='3%'><%=ht.get("�빰���")%></td>
		  <td align="center"	width='3%'><%=ht.get("�ڱ��ü���_������")%></td>
		  <td align="center"	width='3%'><%=ht.get("�ڱ��ü���_�λ�")%></td>
		  <td align="center"	width='3%'><%=ht.get("��������")%></td>
		  <td align="center"	width='3%'><%=ht.get("�����ڱ�δ��")%></td>
		  <td align="center"	width='2%'><%=ht.get("������")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("��������")%></td>
		  <td align="center"	width='3%'><%=ht.get("���ɹ���")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("�����")%></td>
		  <td align="center"	width='4%'><%=ht.get("�Ǻ�����")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("���ʵ����")%></td>
		  <td align="center"	width='2%'><%=ht.get("�������")%></td>
		  <td align="center"	width='2%'><%=ht.get("�뿩���")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("���������")%></td>
		  <td align="center"	width='3%'><%=ht.get("����ó")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("��û")%></td>	  
		</tr>
	
<%	}	%>
		
	  </table>
	</td>
 </tr>
 <%	}else{%>                     
  <tr>
	  <td class='line' width='12%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='88%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>

</body>
</html>
