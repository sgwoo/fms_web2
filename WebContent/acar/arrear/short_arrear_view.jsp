<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.arrear.ArrearDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun"); //������ (����)
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	Vector buss1 = ad_db.getFeeScdSum("0001", "", "3", "3", "1", "", "", "", "", "", "");
	int bus_size1 = buss1.size();
	
	Vector buss2 = ad_db.getFeeScdSum("0002", "", "3", "3", "1", "", "", "", "", "", "");
	int bus_size2 = buss2.size();
	
	
	Vector buss3 = ad_db.getFeeScdSum("9999", "", "3", "3", "1", "", "", "", "", "", "");
	int bus_size3 = buss3.size();
	
	Vector buss4 = ad_db.getFeeScdSum("0007", "", "3", "3", "1", "", "", "", "", "", "");
	int bus_size4 = buss4.size();
					
	Vector buss5 = ad_db.getFeeScdSum("0008", "", "3", "3", "1", "", "", "", "", "", "");
	int bus_size5 = buss5.size();
						

	
	int d_cnt[] 	= new int[6];
	int d_amt[] 	= new int[6];
	int h_cnt[] 	= new int[6];
	int h_amt[] 	= new int[6];
	int t_cnt[] 	= new int[6];
	int t_amt[] 	= new int[6];
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
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
<script language='javascript'>
<!--

	function stat_search(mode, bus_id2){	
		var fm = document.form1;	
		parent.location.href = "/acar/arrear/arrear_frame_s.jsp?gubun1=1&gubun2=3&gubun3=3&gubun4=1&s_kd=8&t_wd="+bus_id2;		
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/index.css">
</head>
<body onLoad="javascript:init()">
<form action="stat_bus_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='bus_size1' value='<%=bus_size1%>'>
<input type='hidden' name='bus_size2' value='<%=bus_size2%>'>
<input type='hidden' name='bus_size3' value='<%=bus_size3%>'>
<input type='hidden' name='bus_size4' value='<%=bus_size4%>'>
<input type='hidden' name='bus_size5' value='<%=bus_size5%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1100>
    <tr id='tr_title' style='position:relative;z-index:1'>
	  <td  width='350' id='td_title' style='position:relative;'> <table width="350" border="0" cellspacing="1" cellpadding="1" bgcolor="#000000" height="61">
          <tr align="center" valign="middle" bgcolor="#6784ba"> 
            <td width="90"><font color="#FFFFFF">�μ�</font></td>
            <td width="72"><font color="#FFFFFF">����</font></td>
            <td width="80"><font color="#FFFFFF">�Ի�����</font></td>
          </tr>
        </table></td>
	<td width='750'>
	    <table width='750' border="0" cellspacing="1" cellpadding="1" bgcolor="#000000" height="61">
          <tr bgcolor="#6784ba" align="center"> 
            <td class=title colspan="2"><font color="#FFFFFF">�հ�</font></td>
            <td class=title colspan="2"><font color="#FFFFFF">�뿩��</font></td>
            <td class=title colspan="2"><font color="#FFFFFF">�����</font></td>
     
          </tr>
          <tr bgcolor="#6784ba" align="center"> 
            <td class=title width="100" ><font color="#FFFFFF">�Ǽ�</font></td>
            <td class=title width="100" ><font color="#FFFFFF">�ݾ�</font></td>
            <td class=title width="100" ><font color="#FFFFFF">�Ǽ�</font></td>
            <td class=title width="100" ><font color="#FFFFFF">�ݾ�</font></td>
            <td class=title width="100" ><font color="#FFFFFF">�Ǽ�</font></td>
            <td class=title width="100" ><font color="#FFFFFF">�ݾ�</font></td>
                
          </tr>
        </table>
	</td>
  </tr>  			  
  <tr>
	  <td class='line' width='350' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width='350' bgcolor="#000000">
          <%for (int i = 0 ; i < bus_size1 ; i++){
				Hashtable ht = (Hashtable)buss1.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <%	if(i==0){%>
            <td align="center" width="90"  rowspan="<%=bus_size1%>" height="20">������</td>
            <%	}else{}%>
            <td align="center" width="72" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
            <td align="center" width="80" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            
          </tr>
          <%		
		  	}%>
		 <%  if  (bus_size1 > 0 ) { %>  	
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="3" height="20">&nbsp;�Ұ�</td>
          </tr>
      	 <%		
		  	}%>
		  	
          <%for (int i = 0 ; i < bus_size2 ; i++){
				Hashtable ht = (Hashtable)buss2.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <%	if(i==0){%>
            <td align="center" width="90"  rowspan="<%=bus_size2%>" height="20">��������</td>
            <%	}else{}%>
            <td align="center" width="72" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
            <td align="center" width="80" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            
          </tr>
          <%		
		  	}%>
		  <%  if  (bus_size2 > 0 ) { %>  		
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="3" height="20">&nbsp;�Ұ�</td>
          </tr>
           <%		
		  	}%>
            <%for (int i = 0 ; i < bus_size3 ; i++){
				Hashtable ht = (Hashtable)buss3.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <%	if(i==0){%>
            <td align="center" width="90"  rowspan="<%=bus_size3%>" height="20">��Ÿ </td>
            <%	}else{}%>
        
            <td align="center" width="72" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
            <td align="center" width="80" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            
          </tr>
          <%		
		  	}%>
		  <%  if  (bus_size3 > 0 ) { %>  		
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="3" height="20">&nbsp;�Ұ�</td>
          </tr>
           <%		
		  	}%>
          <%for (int i = 0 ; i < bus_size4 ; i++){
				Hashtable ht = (Hashtable)buss4.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <%	if(i==0){%>
            <td align="center" width="90"  rowspan="<%=bus_size4%>" height="20">�λ�����</td>
            <%	}else{}%>
            <td align="center" width="72" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
            <td align="center" width="76" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
         
          </tr>
          <%		
		  	}%>
		  <%  if  (bus_size4 > 0 ) { %>  		
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="3" height="20">&nbsp;�Ұ�</td>
          </tr>
           <%		
		  	}%>
          <%for (int i = 0 ; i < bus_size5 ; i++){
				Hashtable ht = (Hashtable)buss5.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <%	if(i==0){%>
            <td align="center" width="90"  rowspan="<%=bus_size5%>" height="20">��������</td>
            <%	}else{}%>
            <td align="center" width="72" height="20"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
            <td align="center" width="76" height="20"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
       
          </tr>
          <%		
		  	}%>
		  <%  if  (bus_size5 > 0 ) { %>  		
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="3" height="20">&nbsp;�Ұ�</td>
          </tr>
           <%		
		  	}%>
		  	
          <tr bgcolor="#FFFFFF"> 
            <td class="star" align="center" colspan="3" height="20">&nbsp;���հ�</td>
           
          </tr>
        </table></td>
        
        
	<td class='line' width='750'>
	    <table border="0" cellspacing="1" cellpadding="0" width='750' bgcolor="#000000">
          <%for (int i = 0 ; i < bus_size1 ; i++){
				Hashtable ht = (Hashtable)buss1.elementAt(i);
				
				d_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				
				%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>��&nbsp;</td>																																				
          </tr>
          <%		
			}%>
		  <%  if  (bus_size1 > 0 ) { %>  		
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_cnt[0])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_amt[0])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_cnt[0])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_amt[0])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_cnt[0])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_amt[0])%>��&nbsp;</td>																																				
          </tr>
           <%		
			}%>
          <%for (int i = 0 ; i < bus_size2 ; i++){
          		Hashtable ht = (Hashtable)buss2.elementAt(i);
				
				d_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				
				%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>��&nbsp;</td>																																				
          </tr>
          <%		
			}%>
		 <%  if  (bus_size2 > 0 ) { %>  			
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_cnt[1])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_amt[1])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_cnt[1])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_amt[1])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_cnt[1])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_amt[1])%>��&nbsp;</td>																																				
          </tr>
             <%		
			}%>
           <%for (int i = 0 ; i < bus_size3 ; i++){
          		Hashtable ht = (Hashtable)buss3.elementAt(i);
				
				d_cnt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				
				%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>��&nbsp;</td>																																				
          </tr>
          <%		
			}%>
		 <%  if  (bus_size3 > 0 ) { %>  			
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_cnt[2])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_amt[2])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_cnt[2])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_amt[2])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_cnt[2])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_amt[2])%>��&nbsp;</td>																																				
          </tr>
             <%		
			}%>
     
          <%for (int i = 0 ; i < bus_size4 ; i++){
				Hashtable ht = (Hashtable)buss4.elementAt(i);
				
				d_cnt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
			%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>��&nbsp;</td>																																					
          </tr>
          <%		
			}%>
		 <%  if  (bus_size4 > 0 ) { %>  			
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_cnt[3])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_amt[3])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_cnt[3])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_amt[3])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_cnt[3])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_amt[3])%>��&nbsp;</td>																																				
          </tr>
           <%		
			}%>
          <%for (int i = 0 ; i < bus_size5 ; i++){
				Hashtable ht = (Hashtable)buss5.elementAt(i);
				
				d_cnt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
		  %>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>��&nbsp;</td>																																					
          </tr>
          <%		
			}%>
		 <%  if  (bus_size5 > 0 ) { %>  			
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_cnt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_amt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_cnt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_amt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_cnt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_amt[4])%>��&nbsp;</td>																																				
          </tr>
            <%		
			}%> 
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_cnt[0]+t_cnt[1]+t_cnt[2]+t_cnt[3]+t_cnt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(t_amt[0]+t_amt[1]+t_amt[2]+t_amt[3]+t_amt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_cnt[0]+d_cnt[1]+d_cnt[2]+d_cnt[3]+d_cnt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(d_amt[0]+d_amt[1]+d_amt[2]+d_amt[3]+d_amt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_cnt[0]+h_cnt[1]+h_cnt[2]+h_cnt[3]+h_cnt[4])%>��&nbsp;</td>
            <td class="is" align="right" height="20" width="100"><%=Util.parseDecimal(h_amt[0]+h_amt[1]+h_amt[2]+h_amt[3]+h_amt[4])%>��&nbsp;</td>																																				
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
