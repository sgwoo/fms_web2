<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*, acar.res_search.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%
	
    String s_user =  request.getParameter("user_id")==null?"":request.getParameter("user_id");	
    String s_work_nm =  request.getParameter("work_nm")==null?"A":request.getParameter("work_nm");	
    String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	int amt 		= request.getParameter("j_amt")==null?0:AddUtil.parseInt(request.getParameter("j_amt"));
	
	String s_year = Integer.toString(AddUtil.getDate2(1));	
	String s_month =Integer.toString(AddUtil.getDate2(2));	
	s_month = AddUtil.addZero(s_month);

      
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
 
<table border="0" cellspacing="0" cellpadding="0" width="100%">

	<tr> 
		<td align='left'>&nbsp; <% if( !s_work_nm.equals("A")){%> <img src=/acar/images/center/arrow_sm.gif> : <%=s_work_nm%> &nbsp; &nbsp;  <%}%></td>
		<td align=right>&nbsp;&nbsp;&nbsp;</font>
		</td>
	</tr>
	
	<tr>
	  <td colspan=2> 
	    <table border="0" cellspacing="0" cellpadding="0" width='100%'>
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������Ÿ�</span></td>
          </tr>
        </table></td>
	
    </tr>
    <tr>
    <td class=line2 colspan=2></td>
  	</tr>
    
<%	
	 Vector vts1 = new Vector();
	
	//20100101 ���� ������ �뿩�� 
	vts1 = rs_db.getRentPrepareList4(s_user);
	   
	int vt_size1 = vts1.size();
	
%>	
	<tr id='tr_title' >
		<td class='line' width='30%' id='td_title' style='position:relative;' > 
			<table border="0" cellspacing="1" cellpadding="0" width='100%' >
				<tr> 
					<td width='40%' class='title' >����</td>
					<td width='60%' class='title' >������</td>
				</tr>
			</table>
		</td>
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td  width='15%' class='title'>������</td>
					<td  width='25%' class='title'>������ȣ</td>
					<td  width='40%'  class='title'>����</td>
					<td  width='20%' class='title'>����Ÿ�</td>
				</tr>
			</table>
		</td>
	</tr>	

<%	if(vt_size1 > 0){%>
  <tr>
	  <td class='line' width='30%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
  
        <%	for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht1 = (Hashtable)vts1.elementAt(i);%>
          <tr> 
          	 <td width='40%' align="center"><%= i+1%></td>
             <td width='60%' align="center"><%=ht1.get("SERV_DT")%></td>
          </tr>
          <%}%>
          <tr> 
            <td class=title align="center" colspan=2>���</td>
          </tr>		  
        </table></td>	
	 <td class='line' width='70%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht1 = (Hashtable)vts1.elementAt(i);
														
					%>
          <tr> 
<%
        long tot = 0;
     
        long remain = 0;
       	
       	long stot = 0;
      
%>           
		    <td width='15%' align="center"><%=ht1.get("RENT_DT")%></td> 
            <td width='25%' align="center"><%=ht1.get("CAR_NO")%></td>
            <td width='40%' align="center"><%=ht1.get("CAR_NM")%></td>
            <td width='20%' align="right"><%=Util.parseDecimal(String.valueOf(ht1.get("TOT_DIST")))%></td>
      
          </tr>
          <%}%>
<%
       long sremain = 0;
   
%>       	        
          <tr> 
          	<td class=title style="text-align:right"></td>
            <td class=title style="text-align:right"></td>
            <td class=title style="text-align:right"></td>
            <td class=title style="text-align:right"></td>
          
           </tr>	  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='30%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='70%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>	
  <tr>
    <td></td>
  </tr>
		    
   	<tr>
	  <td colspan=2> 
	    <table border="0" cellspacing="0" cellpadding="0" width='100%'>
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����볻��</span></td>
          </tr>
        </table></td>
	
    </tr>
  
	<tr><td class=line2  colspan="2"></td></tr>
<%	
	 Vector vts2 = new Vector();
	
	
	vts2 = CardDb.getCardJungOilDtStat(dt, ref_dt1, ref_dt2, s_user);
	   
	int vt_size2 = vts2.size();
				
	    	
%>
	<tr id='tr_title' >
		<td class='line' width='20%' id='td_title' style='position:relative;' > 
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
				<tr> 
					<td width='40%' class='title' rowspan="2" style='height:45'>����</td>
					<td width='60%' class='title' rowspan="2">����</td>
				</tr>
			</table>
		</td>
		<td class='line' width='80%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td  colspan="2"  class='title'>������</td>
					<td  colspan="3"  class='title'>������</td>
					<td  rowspan="2" class='title'>�հ�</td>
				</tr>
				<tr>
					<td width='17%' class='title'>����</td>
					<td width='17%' class='title'>�ʰ��ݾ�</td>
					<td width='16%' class='title'>������(����)</td>
					<td width='16%' class='title'>������</td>
					<td width='17%' class='title'>�Ұ�</td>
				</tr>
			</table>
		</td>
	</tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='20%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	long t_amt1[] = new long[1];
      		long t_amt2[] = new long[1];
        	long t_amt3[] = new long[1];
        	long t_amt4[] = new long[1];
        	long t_amt5[] = new long[1];
        	long t_amt6[] = new long[1];
        	
        %>
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);%>
          <tr> 
          	 <td width='40%' align="center"><%= i+1%></td>
             <td width='60%' align="center"><%=ht.get("BUY_DT")%></td>
          </tr>
          <%}%>
          <tr> 
            <td class=title align="center" colspan=2>�հ�</td>
          </tr>		  
        </table></td>
	<td class='line' width='80%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					for(int j=0; j<1; j++){
				
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_11")));
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_12")));
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_11")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT_12"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_12")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
					}
										
					%>
          <tr> 
<%
        long tot = 0;
        tot = AddUtil.parseLong(String.valueOf(ht.get("AMT_11")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT_12"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
    
        long remain = 0;
       	
       	long stot = 0;
        stot = AddUtil.parseLong(String.valueOf(ht.get("AMT_12")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
%>            
            <td width='17%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT_11")))%>��</td>
            <td width='17%' align="right"><%=Util.parseDecimal(remain)%>��</td>
            <td width='16%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT_12")))%>��</td>
            <td width='16%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT_13")))%>��</td>
            <td width='17%' align="right"><%=Util.parseDecimal(stot)%>��</td>
            <td width='17%' align="right"><%=Util.parseDecimal(tot)%>��</td>
          </tr>
          <%}%>
<%
       long sremain = 0;
       sremain = t_amt1[0] - amt;
       if ( sremain < 0 )     	sremain = 0 ;
       t_amt5[0] =sremain;
%>       	        
          <tr> 
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%>��</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt5[0])%>��</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%>��</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%>��</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt6[0])%>��</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt4[0])%>��</td>
           </tr>	  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='20%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='80%'>
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
