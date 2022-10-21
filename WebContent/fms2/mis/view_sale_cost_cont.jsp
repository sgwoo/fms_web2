<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	//���ķ���κ��� : cost_campaign ���̺�
	Hashtable ht3 = ac_db.getCostCampaignVar2("2");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	String second_per	= (String)ht3.get("SECOND_PER");
	
	Hashtable ht = ac_db.getSaleCostCampaignCase_20081208(rent_mng_id, rent_l_cd, rent_st, cs_dt, ce_dt, second_per);
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

<!--
//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//-->	
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<input type="hidden" name="second_per" value="<%=second_per%>">
<table border="0" cellspacing="0" cellpadding="0" width="4740">
  <tr> 
  	  <td align='right' colspan=2>&nbsp;&nbsp;</td>
  </tr>
  <tr> 
  	  <td class=line2 colspan=2></td>
  </tr>
  <tr id='tr_title' >  
	<td class='line' width='680' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=91>        
          <tr> 
           <td width='30' class='title' rowspan=2>����</td>
           <td width='50' class='title' rowspan=2>����<br>������</td>
		   <td width='50' class='title' rowspan=2>����<br>�븮��</td>
           <td width='100' class='title' rowspan=2>����</td>
           <td width='100' class='title' rowspan=2>����</td>
           <td width='100' class='title' rowspan=2>����<br>��ȣ</td>
           <td width='100' class='title' rowspan=2>���뿩��<br>���簡ġ</td>
           <td width='100' class='title' rowspan=2>����<br>ȿ��</td>
           <td width='50' class='title' rowspan=2>����</td>
          </tr>        
        </table></td>
	<td class='line' width='4060'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=91>
         <tr>
            <td width='50' class='title' rowspan=3>����<br>����</td>
            <td width='50' class='title' rowspan=3>���<br>����</td>
            <td width='50' class='title' rowspan=3>�뵵<br>����</td>
            <td width='50' class='title' rowspan=3>����<br>����</td>
            <td width='50' class='title' rowspan=3>���<br>�Ⱓ</td>      
            <td width='100' class='title' rowspan=3>�뿩<br>������</td>               		 
            <td width='50' class='title' rowspan=3>����<br>���</td>
            <td width='100' class='title' rowspan=3>����<br>�뿩��</td>   
            <td width='100' class='title' rowspan=3>���<br>�뿩��</td>           
            <td width="100" class='title' rowspan=3>������</td>
            <td width="100" class='title' rowspan=3>��ü<br>���<br>����</td>
            <td width="110" class='title' rowspan=3>ī��<br>�����ݾ�</td>
         	<td class="title" colspan=9>����������+��븶��+��Ÿ����</td>
         	<td class="title" colspan=14>����׸�</td>
            <td class="title" colspan=9>��Ÿ����ȿ���ݿ���</td>
                           
          </tr>
          <tr>
          	<td width=100 class="title" rowspan=2>�⺻��<br>������</td>
            <td width=100 class="title" rowspan=2>�Ϲݽ�<br>�߰�������</td>
            <td width=100 class="title" rowspan=2>��븶��</td>
            <td width=100 class="title" rowspan=2>�縮��<br>�ʱ�<br>�������</td>
            <td width=100 class="title" rowspan=2>�縮��<br>�߰���<br>������</td>
            <td width=100 class="title" rowspan=2>ī�����<br>ĳ����</td>
            <td width=100 class="title" rowspan=2>��Ÿ</td>   
            <td width=100 class="title" rowspan=2>�հ�</td> 
            <td width=50 class="title" rowspan=2>���<br>�뿩��<br>���</td> 			
            
            <td width=100 class="title" rowspan=2>�⺻��<br>�ּ�<br>�������</td> 
            <td width=100 class="title" rowspan=2>�Ϲݽ�<br>�ּ�<br>�������</td>  
            <td width=100 class="title" rowspan=2>�縮������<br>������<br>(����)</td>
            <td width=100 class="title" rowspan=2>����<br>�縮������<br>������</td>  
            <td width=100 class="title" rowspan=2>����Ŀ�߰�<br>Ź�ۺ��</td> 
            <td width=100 class="title" rowspan=2>���ú��</td> 
            <td width=100 class="title" rowspan=2>���޿�ǰ</td>  
            <td width=100 class="title" rowspan=2>�����̹ݿ�<br>����ǰ��</td> 
            <td width=100 class="title" rowspan=2>�����ε�<br>Ź�ۺ��</td>  			
            <td width=100 class="title" rowspan=2>�����ε�<br>������</td>  
            <td width=100 class="title" rowspan=2>��Ʈ<br>����⵿<br>���谡�Ժ�</td> 			
            <td width=100 class="title" rowspan=2>��Ÿ<br>���</td> 
            <td class="title" colspan=2>����հ�</td>  
            
            <td width=100 class="title" rowspan=2>����Ŀ<br>����D/C</td>  
            <td width=100 class="title" rowspan=2>����Ŀ<br>�߰�D/C</td> 
            <td width=100 class="title" rowspan=2>�ܰ�����ũ<br>����ȿ��</td>  
            <td width=100 class="title" rowspan=2>�������<br>����ݸ���<br>(����)</td> 
            <td width=100 class="title" rowspan=2>������<br>����ݸ���</td>  
            <td width=100 class="title" rowspan=2>���°�<br>������</td>  
            <td width=100 class="title" rowspan=2>���������</td>  
            <td width=100 class="title" rowspan=2>��Ÿ</td>  						
            <td width=100 class="title" rowspan=2>�հ�</td>               
         </tr>
         <tr>
            <td width=100 class="title" >�Ǻ��</td>  
            <td width=100 class="title" >��ġ</td>   
          </tr>
          
        </table>
	</td>
  </tr>	
  <tr height=100>
	  <td class='line' width='680' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
         <%	      
            long t_af_amt[] 	= new long[1];
            long t_bc_s_g[] 	= new long[1];
        	long t_fee_s_amt[] 	= new long[1];
        	long t_trf_amt[] 	= new long[1];
        	long t_amt1[] 		= new long[1];
      		long t_amt2[] 		= new long[1];
        	long t_amt3[] 		= new long[1];
        	long t_amt4[] 		= new long[1];
        	long t_amt5[] 		= new long[1];
        	long t_amt6[] 		= new long[1];
        	long t_amt7[] 		= new long[1];
        	long t_amt8[] 		= new long[1];
        	long t_amt9[] 		= new long[1];
        	long t_amt10[] 		= new long[1]; 
        	long t_amt11[] 		= new long[1]; //�縮�� ����������
        	long t_amt12[] 		= new long[1];  //����������������������
        	long t_amt13[] 		= new long[1];  //����Ŀ�߰�Ź�ۺ��
        	long t_amt14[] 		= new long[1];  //�����ε����
        	long t_amt15[] 		= new long[1];  //���ú��
        	long t_amt16[] 		= new long[1];  //���޿�ǰ
        	long t_amt17[] 		= new long[1];  //�����̹ݿ뼭��ǰ��
        	long t_amt18[] 		= new long[1];  //�����ε�������
      		long t_amt19[] 		= new long[1];  //��Ÿ���
        	long t_amt20[] 		= new long[1];  //�Ǻ���հ�
        	long t_amt21[] 		= new long[1]; //��ġ�հ�
        	long t_amt22[] 		= new long[1];
        	long t_amt23[] 		= new long[1];
        	long t_amt24[] 		= new long[1];
        	long t_amt25[] 		= new long[1];
        	long t_amt26[] 		= new long[1];
        	long t_amt27[] 		= new long[1]; 
        	long t_amt28[] 		= new long[1]; 
        	long t_amt29[] 		= new long[1];  //
        	long t_amt30[] 		= new long[1];  //
		long t_amt31[] 		= new long[1];  //
		long t_amt33[] 		= new long[1];  //
		long t_amt43[] 		= new long[1];  //
		long t_amt44[] 		= new long[1];  //
        	
        	long t_f_amt8[] 	= new long[1]; 
        	long t_f_amt21[] 	= new long[1];  //
        	long t_f_amt30[] 	= new long[1];  //
        	
        	
        	long a_amt1[] 	= new long[1];
        	long a_amt2[] 	= new long[1]; 
        	long a_amt3[] 	= new long[1]; 
        	long l_amt1[] 	= new long[1];
        	long l_amt2[] 	= new long[1]; 
        	long l_amt3[] 	= new long[1]; 
        	
        	long ea_amt = 0;
        	long af_amt = 0; 
        	long bc_s_g = 0;
        	 
        	float f_af_amt= 0;
        	float f_fee_s_amt= 0;
        	
 		    
					for(int j=0; j<1; j++){
							
					    	t_f_amt8[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));  	//�հ�
						t_f_amt21[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));  //����հ�
						t_f_amt30[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));  //��Ÿȿ���հ�
						t_af_amt[j] 	+= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT"))); //���뿩�����簡ġ
					}
					
				ea_amt = AddUtil.parseLong(String.valueOf(ht.get("AMT8"))) - AddUtil.parseLong(String.valueOf(ht.get("AMT21"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT30"))); //����ȿ��
    				af_amt = AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
    				f_af_amt = AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
		%>
          <tr>
           	 <td align="center" width='30'><%//= i+1%></td> 
             <td align="center" width='50'><%=ht.get("USER_NM")%></td>
             <td align="center" width='50'><%=ht.get("BUS_AGNT_NM")%></td>			 
             <td align="center" width='100'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
             <td align="center" width='100'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
             <td align="center" width='100'><span title='<%=ht.get("CAR_NO")%>'><%=ht.get("CAR_NO")%></span></td>
             <td align="right" width='100'><%=Util.parseDecimal(String.valueOf(ht.get("AF_AMT")))%></td>
             <td align="right" width='100'><%= Util.parseDecimal(ea_amt)%></td>
             <td align="center" width='50'> 
             <% if (  af_amt == 0 ) { %> 0
             <% } else { %> 
             <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt/f_af_amt*100),1)%>
             <% } %>            
			 </td>               
          </tr>
        </table></td>
	<td class='line' width='4060' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%
						for(int j=0; j<1; j++){
						
						t_bc_s_g[j] += AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));//����뿩��	
						t_fee_s_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));//�뿩��		
						t_trf_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));//ī������												
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1")));				
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2")));				
						t_amt3[j]  += AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
						t_amt4[j]  += AddUtil.parseLong(String.valueOf(ht.get("AMT4"))); 
						t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
					  	t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
					    	t_amt9[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
						t_amt10[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
						t_amt11[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT11"))); //�縮�� ����������
						t_amt12[j] +=  AddUtil.parseLong(String.valueOf(ht.get("AMT12"))); //�������縮�� ����������
						t_amt13[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT13")));  // 
						t_amt14[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT14")));  //�����ε�Ź��
						t_amt15[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT15")));  //���ú��
						t_amt16[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT16")));  //���޿�ǰ
						t_amt17[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT17")));  //�����̹ݿ�����ǰ��
						t_amt18[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT18")));  //�����ε�������
						t_amt19[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT19")));  //��Ÿ���
						t_amt20[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT20")));  //�Ǻ��
						t_amt21[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT21")));  //��ġ
						t_amt22[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT22")));  //����Ŀ�Ǹ�dc
						t_amt23[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT23")));  //����Ŀ�߰�dc
						t_amt24[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT24")));  //�ܰ�����ũ����ȿ��
						t_amt25[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT25")));  //���������� ����ݸ���
						t_amt26[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT26")));  //�����������
						t_amt27[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT27")));  //�°������	
						t_amt28[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT28")));  //�����
						t_amt29[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT29")));  //��Ÿ��
						t_amt30[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT30")));  //�հ�
						t_amt33[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT33")));  //��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���
						t_amt43[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT43"))); 
						t_amt44[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT44"))); 
						
					}
						
					bc_s_g = AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));	
					f_fee_s_amt = AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));		
					
								 
				%>
          <tr> 
             <td align="center" width='50'><%=ht.get("CAR_GU_NM")%></td>
             <td align="center" width='50'><%=ht.get("RENT_ST_NM")%></td>
             <td align="center" width='50'><%=ht.get("CAR_ST_NM")%></td>
             <td align="center" width='50'><%=ht.get("RENT_WAY_NM")%></td>
             <td align="center" width='50'><%=ht.get("CON_MON")%></td>
             <td align="center" width='100'><%=ht.get("RENT_START_DT")%></td>		  
	  		<td align="center" width='50'><%=ht.get("SPR_KD_NM")%></td>
            <td align="right" width='100'><%=Util.parseDecimal(String.valueOf(ht.get("BC_S_G")))%></td>
            <td align="right" width='100'><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%></td>
            <td align="right" width='100'>
            <% if (  bc_s_g == 0 ) { %>0<% } else { %><%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g-f_fee_s_amt)/(bc_s_g-t_amt43[0]-t_amt44[0] ) * 100),1)%><% } %>
            <%//=AddUtil.parseFloatCipher(Util.parseDecimal( (bc_s_g/f_fee_s_amt - 1) * 100),1)%>
            </td>
	    <td width="100" align="center"><%=ht.get("COMMI2_NM")%></td>
	    <td width="110" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>  <!--ī�����ݾ�-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%></td>  <!--�⺻�İ�����-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%></td>  <!--�Ϲݽİ�����-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%></td>  <!--��븶��-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%></td>  <!--�縮���ʱ⿵�����-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT5")))%></td>  <!--�縮���߰���������-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT6")))%></td>  <!-- ī�����ĳ����-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT7")))%></td>  <!--��Ÿ-->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT8")))%></td>  <!--�հ� -->
            <td width="50" align="right">
			<% if (  AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT"))) == 0 ) { %> 0
             <% } else { %> 
             <%=AddUtil.parseFloatCipher(Util.parseDecimal(AddUtil.parseFloat(String.valueOf(ht.get("AMT8")))/AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")))*100),1)%>
             <% } %>
			</td>  <!--���뿩���� -->			
            
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT9")))%></td> <!--�⺻���ּҰ������ -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT10")))%></td> <!--�Ϲݽ��ּҰ������ --> 
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT11")))%></td> <!--�縮������������ -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT12")))%></td> <!--�����縮�������� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT13")))%></td> <!--����Ŀ�߰�Ź�� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT15")))%></td> <!--���ú�� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT16")))%></td> <!--���޿�ǰ -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT17")))%></td> <!--�����̹ݿ�����ǰ�� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT14")))%></td> <!--�����ε�Ź�ۺ��  -->			
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT18")))%></td> <!--�����ε������� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT33")))%></td> <!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ��� -->			
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT19")))%></td> <!--��Ÿ��� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT20")))%></td> <!--�Ǻ�� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT21")))%></td> <!--��ġ -->
        
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT22")))%></td> <!--����D/C -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT23")))%></td> <!--�߰�D/C -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT24")))%></td> <!--�ܰ�����ũ����ȿ�� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT25")))%></td> <!--�����������ݸ���  -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT26")))%></td> <!--����������ݸ��� -->
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT27")))%></td> <!--��Ÿ  -->                   
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT28")))%></td> <!--��Ÿ  -->                   
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT29")))%></td> <!--��Ÿ  -->                   						
            <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT30")))%></td> <!--�հ� -->
            
          </tr>
        </table>
	</td>
  </tr>
  <tr> 
  	  <td colspan=2>1. Ư���� ����� ���� �׸��� 100% ��ŭ ���� �� ������� ó����</td>
  </tr>
  <tr> 
  	  <td colspan=2>2. ������ ���� ����</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ���� �縮������ ������� �� �縮������ �������� 50%�� ��</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ����Ŀ ����D/C�� ���� ����ÿ��� �ݿ��ϰ�, ����Ŀ �߰�D/C�� �������� �ݿ��ϰ� �߰��� ����ȿ���� �ݿ� (�ִ�100����)</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ����ĿD/C�� Ź�۷� �߰��߻��� ���� D/C(�߰�Ź�۷�D/C)�� ����D/C �ݾ׿� ����</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * �� ���� ����� �����ݾ� = ������� ����� �����ݾ� - ������� ���뿩�� �Ѿ��� 3%</td>
  </tr>
  <tr> 
  	  <td colspan=2>3. ��Ÿ �ֿ� ����</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ���Ⱓ�� ��������� ���Ⱓ��( = ��༭�� ���Ⱓ - ����� ���� ������ )</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ����뿩��� ����� ���� ���Ⱓ ����, �뿩������ ���� �����</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * �Ϲݽ� �ּҰ�������� �ʿ췮 �Ϲݽ��߰����� ����� ����</td>
  </tr>
  <tr> 
  	  <td colspan=2>&nbsp;&nbsp;&nbsp; * ����Ŀ �߰�Ź�ۺ�� = �� ���Ҹ���Ŀ Ź�۷� -  �������α׷����� ����Ŀ Ź�۷�</td>
  </tr>  
  </table>
</form>
</body>
</html>
