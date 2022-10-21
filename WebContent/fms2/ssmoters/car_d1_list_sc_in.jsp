<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.master_car.*" %>	
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�ڵ������� �˻� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	

	String s_kd 	= request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
				
	Vector vt = mc_db.getSsmotersComAcarExcelList1(gubun3, gubun2, s_kd, st_dt, end_dt, "2", gubun4);
	int vt_size = vt.size();
	
	int total_su = 0;
	long total_amt = 0;
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
	
		//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}			
	

//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
<input type='hidden' name='req_dt' value='<%=AddUtil.getDate()%>'>
<input type='hidden' name='jung_dt' value=''>         
<table border=0 cellspacing=0 cellpadding=0 width="1620">
 <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='26%' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%' height=71>       
          <tr> 
        	<td class="title" width='10%'>����</td>	
            <td width='6%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>			
			<td class="title" width='14%'>û������</td>	  	
			<td class="title" width='21%'>��ü</td>	  	  
			<td class="title" width='17%'>������ȣ</td>
			<td class="title" width='32%'>����</td>
          </tr>
      </table>
	</td>
	<td class='line' width='74%'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%' height=71>    
		<tr>
		 
		  <td class="title" width='2%'>����</td>
		  <td class="title" width='4%'>����</td>
		  <td class="title" width='7%'>��</td>
		  <td class="title" width='3%'>�˻�����</td>		
		  <td class="title" width='6%'>�˻��</td>
		  <td class="title" width='5%'>�˻�����</td>
		  <td class="title" width='3%'>�˻�ݾ�</td>	
		  <td class="title" width='3%'>����Ÿ�</td>	
		  <td class="title" width='3%' >�Ƿ�����</td>		
		  <td class="title" width='8%'>�뿩�Ⱓ</td>			
		  <td class="title" width='3%'>����<br>�����</td>		
		  <td class="title" width='3%'>�������</td>		
		  <td class="title" width='3%'>�뿩���</td>			
		  <td class="title" width='2%'>����<br>�����</td>			  			  
		 		  	  	  	  	     
		</tr>
	  </table>
	</td>
  </tr>

 <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='26%' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
        <tr> 
          <td align="center" width='10%'><%=i+1%></td>  
          <td  width='6%' align='center'> <input type="checkbox" name="ch_cd" value="<%=ht.get("M1_NO")%>"  <% if (!String.valueOf(ht.get("������")).equals("")  ) {%>disabled <% } %> ></td>       
		  <td align="center" width='14%'><%=ht.get("û����")%></td>	 
		     <td align="center" width='21%'><%=Util.subData(String.valueOf(ht.get("��ü")),5)%></td>	  	  	  
		  <td align="center" width='17%'>
		   <a href="javascript:parent.view_jungsan('<%=ht.get("M1_NO")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("GUBUN")%>')" onMouseOver="window.status=''; return true">
                <%=ht.get("������ȣ")%>
            </a></td>		  
		  <td align="center" width='32%'>
		  <span title='<%=ht.get("����")%>'><%=Util.subData(String.valueOf(ht.get("����")),10)%></span></td>
		 
        </tr>      
        <%		}	%>
        
         <tr>                 
		  <td class="title" align="center" colspan=6  >�հ�</td>			 
        </tr>    
       	
      </table>
	</td>
	<td class='line' width='74%'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr>		  
		  <td align="center"	width='2%'><%=ht.get("����")%></td>		   
		  <td align="center"	width='4%'><%=Util.subData(String.valueOf(ht.get("����")),5)%></td>
		  <td align="left"	width='7%'>
		  <span title='<%=ht.get("��")%>'><%=Util.subData(String.valueOf(ht.get("��")),8)%></span></td>
		  <td align="center"    width='3%'><%=ht.get("�˻���")%></td>	  	  
		  <td align="center"	width='6%'><%=Util.subData(String.valueOf(ht.get("�˻��")),8)%></td>
		  <td align="center"	width='5%'><%=ht.get("����")%></td>		
		  <td align="right"  	width='3%'><%=AddUtil.parseDecimal(ht.get("�˻�ݾ�"))%></td>	
		  <td align="right"  	width='3%'><%=AddUtil.parseDecimal(ht.get("����Ÿ�"))%></td>	
		  <td align="center"	width='3%'><%=ht.get("�������")%></td>	 		
		  <td align="center"	width='8%'><%=ht.get("�뿩�Ⱓ")%></td>
		  <td align="center"	width='3%'><%=ht.get("���ʵ����")%></td>
		  <td align="center"	width='3%'><%=ht.get("�������")%></td>
		  <td align="center"	width='3%'><%=ht.get("�뿩���")%></td>	  
		  <td align="center"	width='2%'><%=ht.get("���������")%></td>					 		  	  
		</tr>
<%	total_su = total_su + 1;
	total_amt   = total_amt  + AddUtil.parseLong(String.valueOf(ht.get("�˻�ݾ�")));
}%>
		  					
		<tr>		  
		  <td class="title" align="center"	></td>		   
		  <td class="title" align="center"	></td>
		  <td class="title" align="center"	></td>
		  <td class="title" align="center"  ></td>	  	  
		  <td class="title" align="center"	></td>
	      <td class="title" colspan= 2  style='text-align:right' ><%=Util.parseDecimal(total_amt)%></td>	
		  <td class="title" align="center"	></td>		  
		  <td class="title" align="center"	></td>	 		
		  <td class="title" align="center"	></td>
		  <td class="title" align="center"	></td>
		  <td class="title" align="center"	></td>
		  <td class="title" align="center"	></td>	  
		  <td class="title" align="center"	></td>	
		</tr>
		
	  </table>
	</td>
 </tr>
 <%	}else{%>                     
  <tr>
	  <td class='line' width='26%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='74%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>
</form>
</body>
</html>
