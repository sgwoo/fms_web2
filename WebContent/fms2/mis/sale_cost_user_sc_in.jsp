<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String cs_dt 	= request.getParameter("cs_dt")==null?"":request.getParameter("cs_dt");
	String ce_dt 	= request.getParameter("ce_dt")==null?"":request.getParameter("ce_dt");
	
	if(cs_dt.equals("")) cs_dt = ref_dt1;
	if(ce_dt.equals("")) ce_dt = ref_dt2;
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	Vector vts2 = ac_db.getSaleCostCampaign_20081208(cs_dt, ce_dt, t_wd);
	int vt_size2 = vts2.size();
	
   	long af_amt[]	 		= new long[2];
	long ea_amt[]	 		= new long[2];
	long bc_s_g[]	 		= new long[2];
	long fee_s_amt[]		= new long[2];
	long trf_amt[]			= new long[2];
	
	long a_amt[]	 		= new long[2];
   	long s_tot[]	 		= new long[2];
	long ac_amt[]	 		= new long[2];
	long g_tot[]	 		= new long[2];
	long ave_amt[]			= new long[2];
	
   	float f_amt8[]			= new float[2];
   	float f_af_amt[]		= new float[2];
   	float f_fee_s_amt[]		= new float[2];
	
   	long amt1[]	 			= new long[2];
	long amt2[]	 			= new long[2];
	long amt3[]	 			= new long[2];
	long amt4[]	 			= new long[2];
	long amt5[]	 			= new long[2];
	long amt6[]	 			= new long[2];
	long amt7[]	 			= new long[2];
	long amt8[]	 			= new long[2];
	long amt9[]	 			= new long[2];
	long amt10[] 			= new long[2];
	long amt11[] 			= new long[2];
	long amt12[] 			= new long[2];
	long amt13[] 			= new long[2];
	long amt14[] 			= new long[2];
	long amt15[] 			= new long[2];
	long amt16[] 			= new long[2];
	long amt17[] 			= new long[2];
	long amt18[] 			= new long[2];
	long amt19[] 			= new long[2];
	long amt20[] 			= new long[2];
	long amt21[] 			= new long[2];
	long amt22[] 			= new long[2];
	long amt23[] 			= new long[2];
	long amt24[] 			= new long[2];
	long amt25[] 			= new long[2];
	long amt26[] 			= new long[2];
	long amt27[] 			= new long[2];
	long amt28[] 			= new long[2];
	long amt29[] 			= new long[2];
	long amt30[] 			= new long[2];
	long amt31[] 			= new long[2];
	long amt32[] 			= new long[2];
	long amt33[] 			= new long[2];
	long amt34[] 			= new long[2];
	long amt35[] 			= new long[2];
	long amt36[] 			= new long[2];
	long amt39[] 			= new long[2];
	long amt40[] 			= new long[2];
	long amt43[] 			= new long[2];
	long amt44[] 			= new long[2];
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
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<table border="0" cellspacing="0" cellpadding="0" width="5890">
  <tr> 
  	  <td align='right' colspan=2>&nbsp;&nbsp;</td>
  </tr>
  <tr id='tr_title' >  
	<td class='line' width='450' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=91>        
          <tr> 
           <td width='30' class='title' rowspan=2>����</td>
           <td width='60' class='title' rowspan=2>����<br>������</td>
		   <td width='60' class='title' rowspan=2>����<br>�븮��</td>
           <td width='100' class='title' rowspan=2>����</td>
           <td width='100' class='title' rowspan=2>����</td>
           <td width='100' class='title' rowspan=2>����<br>��ȣ</td>
          </tr>        
        </table></td>
	<td class='line' width='5440'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=91>
         <tr>
            <td width='110' class='title' rowspan=3>���뿩��<br>���簡ġ</td>
            <td width='110' class='title' rowspan=3>����<br>ȿ��</td>
            <td width='80' class='title' rowspan=3>����</td>		 
            <td width='80' class='title' rowspan=3>����<br>����</td>
            <td width='80' class='title' rowspan=3>���<br>����</td>
            <td width='80' class='title' rowspan=3>�뵵<br>����</td>
            <td width='80' class='title' rowspan=3>����<br>����</td>
            <td width='80' class='title' rowspan=3>���<br>�Ⱓ</td>      
            <td width='110' class='title' rowspan=3>�뿩<br>������</td>               		 
            <td width='80' class='title' rowspan=3>����<br>���</td>
            <td width='110' class='title' rowspan=3>����<br>�뿩��</td>   
            <td width='110' class='title' rowspan=3>���<br>�뿩��</td>           
            <td width="80" class='title' rowspan=3>������</td>
            <td width="100" class='title' rowspan=3>��ü<br>���<br>����</td>
            <td width="110" class='title' rowspan=3>ī��<br>�����ݾ�</td>
         	<td class="title" colspan=14>����������+��븶��+��Ÿ����</td>
         	<td class="title" colspan=14>����׸�</td>
            <td class="title" colspan=9>��Ÿ����ȿ���ݿ���</td>
                           
          </tr>
          <tr>
          	<td width=110 class="title" rowspan=2>�⺻��<br>������</td>
            <td width=110 class="title" rowspan=2>�Ϲݽ�<br>�߰�������</td>
            <td width=110 class="title" rowspan=2>��븶��</td>
			<td width=110 class="title" rowspan=2>���Ǻ���<br>���Ժ�</td>
            <td width=110 class="title" rowspan=2>�縮��<br>�ʱ�<br>�������</td>
            <td width=110 class="title" rowspan=2>�縮��<br>�߰���<br>������</td>
            <td width=110 class="title" rowspan=2>ī�����<br>ĳ����</td>
            <td width=110 class="title" rowspan=2>ī�����ĳ����<br>�����ݿ���</td>
            <td width=110 class="title" rowspan=2>���������</td>
            <td width=110 class="title" rowspan=2>�����̰��������</td>            
            <td width=110 class="title" rowspan=2>������Ʈ�����������</td>            
            <td width=110 class="title" rowspan=2>��Ÿ</td>   
            <td width=110 class="title" rowspan=2>�հ�</td> 
            <td width=80 class="title" rowspan=2>���<br>�뿩��<br>���</td> 			
            
            <td width=110 class="title" rowspan=2>�⺻��<br>�ּ�<br>�������</td> 
            <td width=110 class="title" rowspan=2>�Ϲݽ�<br>�ּ�<br>�������</td>  
            <td width=110 class="title" rowspan=2>�縮������<br>������<br>(����)</td>
            <td width=110 class="title" rowspan=2>����<br>�縮������<br>������</td>  
            <td width=110 class="title" rowspan=2>����Ŀ�߰�<br>Ź�ۺ��</td> 
            <td width=110 class="title" rowspan=2>���ú��</td> 
            <td width=110 class="title" rowspan=2>���޿�ǰ</td>  
            <td width=110 class="title" rowspan=2>�����̹ݿ�<br>����ǰ��</td> 
            <td width=110 class="title" rowspan=2>�����ε�<br>Ź�ۺ��</td>  			
            <td width=110 class="title" rowspan=2>�����ε�<br>������</td>  
            <td width=110 class="title" rowspan=2>��Ʈ<br>����⵿<br>���谡�Ժ�</td> 			
            <td width=110 class="title" rowspan=2>��Ÿ<br>���</td> 
            <td class="title" colspan=2>����հ�</td>  
            
            <td width=110 class="title" rowspan=2>����Ŀ<br>����D/C<br>(����)</td>  
            <td width=110 class="title" rowspan=2>����Ŀ<br>�߰�D/C<br>(�ݿ���)</td> 
            <td width=110 class="title" rowspan=2>�ܰ�����ũ<br>����ȿ��</td>  
            <td width=110 class="title" rowspan=2>�������<br>����ݸ���<br>(����)</td> 
            <td width=110 class="title" rowspan=2>������<br>����ݸ���</td>  
            <td width=110 class="title" rowspan=2>���°�<br>������</td>  
            <td width=110 class="title" rowspan=2>���������</td>  
            <td width=110 class="title" rowspan=2>��Ÿ</td>  						
            <td width=110 class="title" rowspan=2>�հ�</td>               
         </tr>
         <tr>
            <td width=110 class="title" >�Ǻ��</td>  
            <td width=110 class="title" >��ġ</td>   
          </tr>
          
        </table>
	</td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr height=100>
	  <td class='line' width='450' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
         <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);%>
          <tr>
           	 <td align="center" width='30'><%= i+1%></td> 
             <td align="center" width='60'><%=ht.get("USER_NM")%></td>
             <td align="center" width='60'><%=ht.get("BUS_AGNT_NM")%></td>			 
             <td align="center" width='100'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
             <td align="center" width='100'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
             <td align="center" width='100'><span title='<%=ht.get("CAR_NO")%>'><%=ht.get("CAR_NO")%></span></td>
          </tr>
          <%}%>
          <tr> 
             <td class=title style='text-align:center;' colspan=6>�հ�</td>
          </tr>		  
        </table></td>
	<td class='line' width='5440' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < vt_size2 ; i++){
					    Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 	= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					trf_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
					f_af_amt[0] 	= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_fee_s_amt[0] 	= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					amt1[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					amt3[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					amt4[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
					amt5[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
					amt6[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
					amt7[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
					amt8[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
					amt9[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
					amt10[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
					amt11[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT11")));
					amt12[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT12")));
					amt13[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT13")));
					amt14[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT14")));
					amt15[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT15")));
					amt16[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT16")));
					amt17[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT17")));
					amt18[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT18")));
					amt19[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT19")));
					amt20[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT20")));
					amt21[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));
					amt22[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT22")));
					amt23[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT23")));
					amt24[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT24")));
					amt25[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT25")));
					amt26[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT26")));
					amt27[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT27")));
					amt28[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT28")));
					amt29[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT29")));
					amt30[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));
					amt31[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT31")));
					amt32[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT32")));
					amt33[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT33")));
					amt34[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT34")));
					amt35[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT35")));
					amt36[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT36")));
					amt39[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT39")));
					amt40[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT40")));
					amt43[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT43")));
					amt44[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT44")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[1] 		+= af_amt[0];
					bc_s_g[1] 		+= bc_s_g[0];
					fee_s_amt[1] 		+= fee_s_amt[0];
					trf_amt[1] 		+= trf_amt[0];
					f_af_amt[1] 		+= f_af_amt[0];
					f_fee_s_amt[1] 		+= f_fee_s_amt[0];
					f_amt8[1] 		+= f_amt8[0];
					ea_amt[1] 		+= ea_amt[0];
					
					amt1[1] 		+= amt1[0];
					amt2[1] 		+= amt2[0];
					amt3[1] 		+= amt3[0];
					amt4[1] 		+= amt4[0];
					amt5[1] 		+= amt5[0];
					amt6[1] 		+= amt6[0];
					amt7[1] 		+= amt7[0];
					amt8[1] 		+= amt8[0];
					amt9[1] 		+= amt9[0];
					amt10[1] 		+= amt10[0];
					amt11[1] 		+= amt11[0];
					amt12[1] 		+= amt12[0];
					amt13[1] 		+= amt13[0];
					amt14[1] 		+= amt14[0];
					amt15[1] 		+= amt15[0];
					amt16[1] 		+= amt16[0];
					amt17[1] 		+= amt17[0];
					amt18[1] 		+= amt18[0];
					amt19[1] 		+= amt19[0];
					amt20[1] 		+= amt20[0];
					amt21[1] 		+= amt21[0];
					amt22[1] 		+= amt22[0];
					amt23[1] 		+= amt23[0];
					amt24[1] 		+= amt24[0];
					amt25[1] 		+= amt25[0];
					amt26[1] 		+= amt26[0];
					amt27[1] 		+= amt27[0];
					amt28[1] 		+= amt28[0];
					amt29[1] 		+= amt29[0];
					amt30[1] 		+= amt30[0];
					amt31[1] 		+= amt31[0];
					amt32[1] 		+= amt32[0];
					amt33[1] 		+= amt33[0];
					amt34[1] 		+= amt34[0];
					amt35[1] 		+= amt35[0];
					amt36[1] 		+= amt36[0];
					amt39[1] 		+= amt39[0];
					amt40[1] 		+= amt40[0];
					amt43[1] 		+= amt43[0];
					amt44[1] 		+= amt44[0];
					
				%>
          <tr> 
	  		<td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--���뿩�����簡ġ -->
	  		<td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--����ȿ�� -->
	  		<td width="80" align="right">
			  <% if (  af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--���� -->			
             <td align="center" width='80'><%=ht.get("CAR_GU_NM")%>&nbsp;</td>
             <td align="center" width='80'><%=ht.get("RENT_ST_NM")%>&nbsp;</td>
             <td align="center" width='80'><%=ht.get("CAR_ST_NM")%>&nbsp;</td>
             <td align="center" width='80'><%=ht.get("RENT_WAY_NM")%>&nbsp;</td>
             <td align="center" width='80'><%=ht.get("CON_MON")%>&nbsp;</td>
             <td align="center" width='110'><%=ht.get("RENT_START_DT")%>&nbsp;</td>		  
	  		<td align="center" width='80'><%=ht.get("SPR_KD_NM")%>&nbsp;</td>
	  		<td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--����뿩�� -->
	  		<td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--���뿩�� -->						
	  		<td width="80" align="right">
			  <% if (  bc_s_g[0] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
			  <% } %>&nbsp;
			</td>  <!--������ -->
	  		<td width="100" align="center"><%=ht.get("COMMI2_NM")%>&nbsp;</td>
	  		<td width="110" align="right"><%=Util.parseDecimal(trf_amt[0])%>&nbsp;</td>  <!--ī�����ݾ�-->
            <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--�⺻�İ�����-->
            <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--�Ϲݽİ�����-->
            <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--��븶��-->
			<td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--���Ǻ��谡�Ժ�-->
            <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--�縮���ʱ⿵�����-->
            <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--�縮���߰���������-->
            <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- ī�����ĳ����-->
            <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- ī�����ĳ��������ݿ���-->
            <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- ���������-->
            <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- �����̰��������-->
            <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- �����̰��������-->
            <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--��Ÿ-->
            <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--�հ� -->
	  		<td width="80" align="right">
			  <% if (  f_af_amt[0] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
              <% } %>&nbsp;
			</td>  <!--���뿩���� -->									                        
            <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--�⺻���ּҰ������ -->
            <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--�Ϲݽ��ּҰ������ --> 
            <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--�縮������������ -->
            <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--�����縮�������� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--����Ŀ�߰�Ź�� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--���ú�� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--���޿�ǰ -->
            <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--�����̹ݿ�����ǰ�� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--�����ε�Ź�ۺ��  -->			
            <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--�����ε������� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->			
            <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--��Ÿ��� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--�Ǻ�� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--��ġ -->
        
            <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--����D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--�߰�D/C -->
            <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--�ܰ�����ũ����ȿ�� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--�����������ݸ���  -->
            <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--����������ݸ��� -->
            <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--�°������ -->
            <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--�����    --> 	
            <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--��Ÿ  -->                   
            <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--�հ� -->
            
          </tr>
          <%}%>
    
           <tr> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[1] == 0 ) { %> 0
              <% } else { %> 
              <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[1]/f_af_amt[1]*100),2)%>
              <% } %>&nbsp;</td>		  
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>
             <td class=title style='text-align:center;'>&nbsp;</td>			 			 			 			 			 			 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[1])%>&nbsp;</td>		  
            <td class=title style='text-align:right;'>
			  <% if (  bc_s_g[1] == 0 ) { %> 0
			  <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[1]-f_fee_s_amt[1])/(bc_s_g[1]-amt43[1]-amt44[1]) ) * 100),2)%>
			  <% } %>&nbsp;</td>		  												
            <td class=title style='text-align:right;'>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(trf_amt[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[1])%>&nbsp;</td>
			<td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'>
			  <% if (  af_amt[1] == 0 ) { %> 0
              <% } else { %> 
			  <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[1]/f_af_amt[1]*100),2)%>
              <% } %>&nbsp;</td>		  			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[1])%>&nbsp;</td>                       
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[1])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[1])%>&nbsp;</td>			
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[1])%>&nbsp;</td> 
    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[1])%>&nbsp;</td> 			
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[1])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[1])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[1])%>&nbsp;</td>             
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[1])%>&nbsp;</td>  
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[1])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[1])%>&nbsp;</td> 
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[1])%>&nbsp;</td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[1])%>&nbsp;</td>          
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
	<td class='line' width='5440'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
  <tr> 
  	  <td colspan=2>1. ������� : 6���� �̻� ��� ����</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * 6���� �̸� ���� : �Ѱ�ళ������ ����ȿ�� ������ �ݿ�</td>
  </tr>
  <tr> 
  	  <td colspan=2>2. ���� �縮������ ������� �� �縮������ �������� 50% </td>
  </tr>
  <tr> 
  	  <td colspan=2>3. ����Ŀ �߰�Ź�ۺ�� = �� ���� ����Ŀ Ź�۷� - �������α׷����� ����Ŀ Ź�۷�</td>
  </tr>
  <tr> 
  	  <td colspan=2>4. ����Ŀ �߰�D/C : �������� �ݿ��ϰ� �߰��� ����ȿ���� �� �ݿ� </td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * �Һ��������� 5%������ 50%, 5%�ʰ��п� ���ؼ��� 20% �ݿ� (���ް� ����)</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ����Ŀ D/C�� Ź�۷� �߰� ���࿡ ���� D/C(�߰�Ź�۷�D/C)�� ���� D/C�ݾ׿� ���� </td>
  </tr>
  <tr> 
  	  <td colspan=2>5. ������ ����� �����ݾ� = ������ ����� �����ݾ� - �Ű�� ���뿩���Ѿ��� 3% (�����뿩��*���Ⱓ*3%) </td>
  </tr>
  <tr> 
  	  <td colspan=2>6. ����� �߻� </td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ���� ����� ��������� ������� ����������� ����</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> �����������(����) : �Ϲ����� 30%, ������ 35%, ������ 40%
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * �縮��/������ �縮������/���������� ���ؼ� ����ȿ�� ���̳ʽ� ó���� ��ü�� </td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> ���̳ʽ� ó�� �� = ���̿�Ⱓ����ȿ�� - ���Ⱓ ����ȿ��</tr>  
  <tr> 
  	  <td colspan=2>7. �߰��̿��� ���ʿ�����(�Ǵ� ���� �������)���� 50%, ���� ��������ڿ��� 50% �ͼӵ� </td>
  </tr>  
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ���°������ : ���� ��������ڿ��� 100% �ͼ�</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * �� �ΰ����� ������ ��� ����ȿ���� ���ʿ�����(�Ǵ� ���� �������)�� �����븮�ο��� �ͼӵ� </td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> �����븮�ο��� �־����� ���� : 20% (���� ������ ���� ����)</td>
  </tr>
  <tr>
    <td colspan=2>8. �򰡹ݿ� ������</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * ����/�縮��/���� - �뿩������</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * �縮������/��������/�߰��̿� - ��������</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * ���°������ - �°�����</td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * ��������ݹ߻� - �������� </td>
  </tr>
  <tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp; * ��������ݼ���/�縮������ݼ���/��������ݼ��� - ��������</td>
  </tr>
  <tr>
    <td colspan=2>9. ��� ����ȿ���� �򰡴� 2008-12-01 ���� �뿩���õ� �ǿ��� ���� (��, ���°������� �뿩������ ������ ����) </td>
  </tr>
  </table>
</form>
</body>
</html>
