<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.incom.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	Vector vt =  a_db.getIncomList("C", t_wd, dt, ref_dt1, ref_dt2);
	int incom_size = vt.size();
	
	String value[] = new String[2];	
	
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
	

//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='1030'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='450' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='50' class='title'>����</td>
          <td width='100' class='title'>����(ī��)</td>
          <td width='170' class='title'>����(ī��)��ȣ</td>
          <td width="130" class='title'>�ŷ�����</td>
        </tr>
      </table>
	</td>
	<td class='line' width='580'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		  <td width="100" class='title'>ó������</td>
		  <td width="200" class='title'>����</td>
		  <td width="80" class='title'>�Աݾ�</td>
		  <td width="200" class='title'>�ŷ���</td>		  	     
		</tr>
	  </table>
	</td>
  </tr>
  <%if(incom_size > 0){%>
  <tr>		
    <td class='line' width='450' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='450'>
        <%	for(int i = 0 ; i < incom_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				StringTokenizer st = new StringTokenizer(String.valueOf(ht.get("BANK_NM")),":");
				int s=0; 
				while(st.hasMoreTokens()){
						value[s] = st.nextToken();
						s++;
				}
								
		%>
        <tr> 
          <td width='50' align='center'><%=i+1%></td>
     <% if (ht.get("IP_METHOD").equals("2")   ) {%>             
          <td width='100' align='center'><%=ht.get("CARD_NM")%></td>
          <td width='170' align='center'><%=ht.get("CARD_NO")%></td>
     <% } else { %>
            <td width='100' align='center'><%=value[1]%></td>
          <td width='170' align='center'><%=ht.get("BANK_NO")%></td>
     <% } %>      
          
          <td width='130' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
        </tr>
      
        <%		}	%>
        <tr>
            <td class="title" align='center' colspan=4>�հ�</td>
	    </tr>	
      </table>
	</td>
	<td class='line' width='580'>
	  <table border="0" cellspacing="1" cellpadding="0" width='580'>
        <%	for(int i = 0 ; i < incom_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr>
		  <td width='100' align='center'><a href="javascript:parent.view_incom_b('<%=ht.get("JUNG_TYPE")%>', '<%=ht.get("INCOM_DT")%>', '<%=ht.get("INCOM_SEQ")%>', '<%=ht.get("INCOM_AMT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=ht.get("JUNG_ST_NM")%></a></td>
		  <td width='200' align='center'><%=Util.subData(String.valueOf(ht.get("REMARK")), 15)%></td>					
		  <td width='80' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%></td>
		  <td width='200' align='center'><%=ht.get("BANK_OFFICE")%></td>
		</tr>
	
<%		total_amt  = total_amt  + Long.parseLong(String.valueOf(ht.get("INCOM_AMT")));
	}	%>
		<tr>
            <td class="title" align='center' colspan=2></td>
            <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
            <td class="title" align='center' ></td>
	    </tr>	
	  </table>
	</td>
 </tr>
 <%	}else{%>                     
  <tr>
	  <td class='line' width='450' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='580'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=incom_size%>';
//-->
</script>
</body>
</html>

