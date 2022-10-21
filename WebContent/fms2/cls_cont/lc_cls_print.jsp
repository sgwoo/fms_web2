<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.credit.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
		
	//�˻�����
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String gg = request.getParameter("gg")==null?"":request.getParameter("gg");
	
	
	//��� ����� ����Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�⺻����
	Hashtable fee_base = af_db.getFeebasecls3(rent_mng_id, rent_l_cd);

	//�뿩������ ����
	int scd_size = Integer.parseInt(a_db.getFeeScdYn(rent_mng_id, rent_l_cd, "1"));

	//�뿩�������� ��ü����Ʈ
	Vector fee_scd = af_db.getFeeScdDly(rent_mng_id);
	int fee_scd_size = fee_scd.size();


	//�����Ƿ�����
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
	
	
	//������Ÿ �߰� ����
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);
	
		//�⺻����
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
	
	
	int pp_amt = AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT"));
	

//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	ContCarBean  car1 =  new ContCarBean();
		//fee ��Ÿ - ����Ÿ� �ʰ��� ���  - fee_etc ��  over_run_amt > 0���� ū ��� �ش��
    if ( cls_st.equals("����Ʈ����")) {
   		  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
    } else {	
		  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	}
		
	ClsEtcOverBean co = ac_db.getClsEtcOver(rent_mng_id, rent_l_cd);
		
	// ��������������	
	ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);
	
	ClsEtcAddBean clsa 	= ac_db.getClsEtcAddInfo(rent_mng_id, rent_l_cd);
	
	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getClsEtcDetailList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
	
	int maeip_amt = 0;	 //���Կɼ��� ��� ��ü�Ա� 
	int m_ext_amt = 0;  //���Կɼ��� ��� ȯ��/������ 
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<!--<link rel=stylesheet type="text/css" href="../../include/table.css">-->
<link rel=stylesheet type="text/css" href="../../include/table_p.css">
<!-- <style>
.a4 { page: a4sheet; page-break-after: always }
</style> -->

<style type="text/css" media="print">
    @page {
        size:  auto;
        margin: 5mm 0mm 5mm 0mm;
    }
    html {
        background-color: #FFFFFF;
        margin: 0px;
    }
    body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.8); */    	
        /* margin���� ����Ʈ ���� ���� */
        /* IE */
        margin: 0mm 0mm 0mm 18mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*���*/
		-webkit-margin-end: 0mm; /*����*/
		-webkit-margin-after: 0mm; /*�ϴ�*/
		-webkit-margin-start: 20mm; /*����*/
    }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//�����ݾ����� ����
	function set_a_amt(){
		var fm = document.form1;	
			
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value))   + toInt(parseDigit(fm.ex_ip_amt.value)) );
		set_cls_amt();		
	}
	
	//�̳��Աݾ����� ����
	function set_b_amt(){
		var fm = document.form1;
		set_cls_amt();
	}	
	
	//�������Ͻ� �ݾ� ����
	function set_c_amt(){
		var fm = document.form1;	
		fm.fdft_amt1_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value)) );
		set_cls_amt();
	}	
				
	//�������Ͻ� �ݾ� ����
	function set_cls_amt(){
		var fm = document.form1;	
		
		fm.fdft_amt2.value 		= 	parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value))  + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );			
	}	
	
	//�����
		
//-->
</script>
<script language="JavaScript" type="text/JavaScript">	
	/* function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 10.0; //��������   
		factory.printing.rightMargin 	= 10.0; //��������
		factory.printing.topMargin 	= 5.0; //��ܿ���    
		factory.printing.bottomMargin 	= 5.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	
	} */
	function ieprint() {
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 10.0; //��������   
		factory.printing.rightMargin 	= 10.0; //��������
		factory.printing.topMargin 	= 5.0; //��ܿ���    
		factory.printing.bottomMargin 	= 5.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}
	
	function onprint() {
		var userAgent=navigator.userAgent.toLowerCase();
		
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			ieprint();
		}
	}

</script>

</head>

<body onLoad="javascript:onprint();">

<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name='form1' method='post' >
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
<input type='hidden' name='rent_way' value='<%=ext_fee.getRent_way()%>'>
<input type='hidden' name='con_mon' value='<%=fee_base.get("TOT_CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
<input type='hidden' name='fee_chk' value='<%=fee_base.get("FEE_CHK")%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

   <!--�ʰ����� �Ÿ� ��� -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>
  
<input type='hidden' name='sh_km' value='<%=car1.getSh_km()%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=650>
    <tr align="center"> 
       <td colspan="2"><font color="#006600">&lt; 
       <% if  (  !gg.equals("m") ) { %>���뿩 <% } %> <%=cls.getCls_st()%> ���꼭 &gt;</font></td>
    </tr>  
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>����ȣ</td>
            <td width="15%"><%=rent_l_cd%></td>
            <td width='10%' class='title'>��ȣ</td>
            <td colspan="3"><%=fee_base.get("FIRM_NM")%></td>
            <td class='title' width="10%">����</td>
            <td width="15%"><%=fee_base.get("CLIENT_NM")%></td>
          </tr>
          <tr> 
            <td class='title' width="10%">������ȣ</td>
            <td width="15%"><font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
            <td width='10%' class='title'>����</td>
            <td colspan="3"><%=fee_base.get("CAR_NM")%></td>
            <td class='title' width="10%">���ʵ����</td>
            <td><%=fee_base.get("INIT_REG_DT")%></td>
          </tr>
          <tr> 
            <td class='title' width="10%">�뿩���</td>
            <td width="15%"><font color="#000099"> 
              <%if(ext_fee.getRent_way().equals("1")){%>
              �Ϲݽ� 
              <%}else if(ext_fee.getRent_way().equals("2")){%>
              ����� 
              <%}else{%>
              �⺻�� 
              <%}%>
              </font></td>
            <td class='title' width="10%">�뿩�Ⱓ</td>
            <td colspan="3"><%=fee_base.get("RENT_START_DT")%>~&nbsp; 
              <%if(fee_base.get("RENT_ST").equals("1")){ out.println(fee_base.get("RENT_END_DT")); }else{ out.println(fee_base.get("EX_RENT_END_DT")); }%>
            </td>
            <td class='title' width="10%">���Ⱓ</td>
            <td><%=fee_base.get("TOT_CON_MON")%> ����</td>
          </tr>
          <tr> 
            <td class='title' width="10%">���뿩��</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
              <%}%>
              ��</td>
            <td class='title' width="10%">������</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("PP_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_PP_AMT"))%> 
              <%}%>
              ��</td>
            <td class='title' width="10%">���ô뿩��</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("IFEE_AMT"))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal((String)fee_base.get("EX_IFEE_AMT"))%>
			  <%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>  
              <%}%>
              ��</td>
            <td class='title' width="10%">������</td>
            <td> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("GRT_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_GRT_AMT"))%> 
              <%}%>
              ��</td>
          </tr>
          <!-- ���Կɼ��� ���  -->
         <%if( cls.getCls_st().equals("���Կɼ�") ) {%> 
          <tr> 
            <td class='title' width="10%">���Կɼ�<br>(��༭)</td>
            <td colspan=7>             
              <%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>            
              ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT����)</td> 	
          
          </tr>
        <% } %>  
        </table>
      </td>
    </tr>
   
    <tr>
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>��������</td>
            <td width="15%"><%=cls.getCls_st()%> 
            </td>
            <td width='10%' class='title'>������</td>
            <td width="15%"> 
              <%=AddUtil.ChangeDate2(cls.getCls_dt()) %>
            </td>
            <td class='title' width="10%">�̿�Ⱓ</td>
             <td colspan=3> 
              <%=cls.getR_mon()%>
              ���� 
              <%=cls.getR_day()%>
              ��</td>          
          </tr>
		   <tr> 
            <td width='10%' class='title'>����Ÿ�</td>
            <td width="15%"> &nbsp;<%=AddUtil.parseDecimal(cls.getTot_dist())%> km</td>
            <td width='10%' class='title'>
            <%if( cls.getCls_st_r().equals("14") ){%> �������ϸ���(��)<%}else{%> �������ϸ���(��)<%}%>
           
      		</td>
            <td colspan=5> 
              &nbsp;<%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
            
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
    </tr>	
        
    <!-- ���Կɼ��� ��� ���Կɼ� ���� ����  -->
   
    <tr id=tr_opt <%if( !cls.getCls_st().equals("���Կɼ�") ) {%> style='display:none;'<%}%>> 

 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կɼ�</span></td>
 	 	  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	 <input type='hidden' name='opt_amt' value='<%=AddUtil.parseDecimal(cls.getOpt_amt())%>' >
		    	 <input type='hidden' name='sui_d_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%>' >
		    	 
		          <tr> 
		             <td class='title' width="13%">���Կɼǰ�</td>
		             <td colspan=6 >&nbsp;<%=AddUtil.parseDecimal(cls.getOpt_amt())%> ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT����)</td> 		           
                  </tr>	
 <% if ( clsm.getSui_d1_amt()     > 0 ) { %>                                                   
		          <tr> 
		 	 	     <td class='title' width="13%" rowspan=3>������Ϻ��</td>
		             <td class='title' width="13%">��ϼ�</td>
		             <td width="13%"  align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d1_amt())%> �� 
		             <td class='title' width="13%">ä������</td>
		             <td width="13%"  align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d2_amt())%> �� 
		             <td class='title' width="13%">��漼</td>
		             <td  align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d3_amt())%> �� </td>
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">������</td>
		             <td width="13%"   align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d4_amt())%> ��
		             <td class='title' width="13%">������</td>
		             <td width="13%" align="center"  >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d5_amt())%> ��
		             <td class='title' width="13%">��ȣ�Ǵ�</td>
		             <td  align="center"  >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d6_amt())%> �� </td>
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">������ȣ�Ǵ�</td>
		             <td width="13%"  align="center"  >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d7_amt())%> ��
		             <td class='title' width="13%">��ϴ����</td>
		             <td width="13%"  align="center"  >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d8_amt())%> ��
		             <td class='title' width="13%">��</td>
		             <td  align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%> ��</td>
		          </tr>  
		<% } %>	          
		       </table>
		      </td>        
         </tr>   
      <%if (clsa.getMt().equals("1") ||  clsa.getMt().equals("2")) {%>  
        <tr>
        	<td>&nbsp;* ���Կɼǰ� �����</td>
    	</tr>
    	 <%if (clsa.getMt().equals("2")) {%>  
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= ������ ���Կɼ� - (������ ���Կɼ� ������  * �̿��ϼ� / �������ϼ�)</td>
    	   </tr>
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= <%=AddUtil.parseDecimal(clsa.getB_old_opt_amt())%> - {(<%=AddUtil.parseDecimal(clsa.getB_old_opt_amt())%> -<%=AddUtil.parseDecimal(clsa.getOld_opt_amt())%>) * <%=clsa.getCount1()%> / <%=clsa.getCount2()%>}</td>
    	   </tr>
    	
    	 <% } else { %>
    	     <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= ���� ���Կɼǰ��� * ���簡ġ��  + �ڵ�����,����� ���ܿ���� ���簡ġ �հ�</td>
    	   </tr>
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= <%=AddUtil.parseDecimal(clsa.getOld_opt_amt())%> * <%=clsa.getRc_rate()%> + <%=AddUtil.parseDecimal(clsa.getM_r_fee_amt())%></td>
    	   </tr>
    	 <% } %>
        <% } %>
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>       
     	</table>
      </td>	 
    </tr>	  	 	    
       
    <tr id=tr_default style="display:''"> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ݾ� ����</span></td>
            <td align="right">[���ް�]</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' align='right' colspan="3">�׸�</td>
                  <td class='title' width='25%' >����</td>
                  <td class='title' width="10%">��������</td>
                  <td class='title' width="35%">���</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="7">ȯ<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td class='title' colspan="2">������(A)</td>
                  <td width="25%" align="center" > 
                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    ��</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td width="20%" align="center" >����Ⱓ</td>
                  <td width="25%" align="center"> 
                    <input type='text' size='3' name='ifee_mon' value='<%=cls.getIfee_mon()%>' class='whitenum' maxlength='4' >
                    ����
                    <input type='text' size='3' name='ifee_day' value='<%=cls.getIfee_day()%>' class='whitenum' maxlength='4' >
                    ��</td>
                  <td>&nbsp;</td>
                   <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td width="20%" align="center">����ݾ�</td>
                  <td width="25%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    ��</td>
                    <td>&nbsp;</td>
                  <td>=���ô뿩�᡿����Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ���ô뿩��(B)</td>
                  <td width='25%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    ��</td>
                   <td>&nbsp;</td>
                  <td>=���ô뿩��-����ݾ�</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��</td>
                  <td align='center' width="20%">�������� </td>
                  <td width='25%' align="center"> 
                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                  <td>&nbsp;</td>  
                  <td>=�����ݡ����Ⱓ</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">������ �����Ѿ� </td>
                  <td width='25%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    ��</td>
                  <td>&nbsp;</td>  
                  <td>=�������ס����̿�Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ������(C)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                   <td>&nbsp;</td>  
                  <td>=������-������ �����Ѿ�</td>
                </tr>
                 <input type='hidden' name='ex_ip_amt' >
             
                <tr> 
                  <td class='title' align='right' colspan="3">��</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='c_amt' value='' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td>&nbsp;</td>  
                  <td>=(A+B+C)</td>
                </tr>
              
              </table>			
            </td>
          </tr>
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳��Աݾ� ����</span></td>
            <td align='right'>[���ް�]</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class="title" colspan="4">�׸�</td>
                  <td class="title" width='25%'>����</td>
                  <td class="title" width='10%'>��������</td>
                  <td class="title" width='35%'>���</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="19" width="5%">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td colspan="3" class="title">���·�/��Ģ��(D)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='fine_amt_1' value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                   <td  align="center">&nbsp;<%if(cls.getFine_amt_1() > 0 ){%>����� <% } %></td>
                  <td >&nbsp;* ���·�߻��� ����ں������� ���� ���ұ������ ���� û���մϴ�.</td>
                </tr>
                 <tr> 
                  <td colspan="3" class="title">�ڱ��������ظ�å��(E)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='car_ja_amt_1' value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    �� </td>
                  <td  align="center">&nbsp;<%if(cls.getCar_ja_amt_1() > 0 ){%>����� <% } %></td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                   <td class="title" rowspan="4" width="5%"><br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">������</td>
                  <td align="center" width='25%' >&nbsp; 
                    <input type='text' name='ex_di_amt_1' value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                  ��&nbsp; </td>
                    <td >&nbsp;</td> 
                  <td >&nbsp; </td>
                </tr>
                <tr> 
                  <td rowspan="2" align="center" width="10%">�̳�</td>
                  <td width='10%' align="center">�Ⱓ</td>
                  <td align="center"> &nbsp; 
                    <input type='text' size='3' name='nfee_mon' value='<%=cls.getNfee_mon()%>' class='whitenum' maxlength='4'>
                    ���� 
                    <input type='text' size='3' name='nfee_day' value='<%=cls.getNfee_day()%>' class='whitenum'  maxlength='4'>
                  ��</td>
                     <td >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">�ݾ�</td>
                  <td align="center" width='25%' > 
                    <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��</td>
                  <td  align="center">&nbsp;<%if(cls.getNfee_amt_1() !=  0 ){%>���� <% } %></td>
                  <td > </td>
                </tr>
               
                <tr> 
                  <td class="title" colspan="2">�Ұ�(F)</td>
                  <td  align="center">
                    <input type='text' name='dfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                  �� </td>
                     <td >&nbsp;</td>
                  <td >&nbsp;</td>
                    <input type='hidden' name='d_amt' size='15' class='whitenum' >
                </tr>
                <tr> 
                  <td rowspan="6" class="title">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">�뿩���Ѿ�</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��</td>
                     <td >&nbsp;</td>
                  <td >=������+���뿩���Ѿ�</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">���뿩��(ȯ��)</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��</td>
                     <td >&nbsp;</td>
                  <td >=�뿩���Ѿס����Ⱓ</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��뿩���Ⱓ</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='rcon_mon' size='3' value='<%=cls.getRcon_mon()%>' class='whitenum' maxlength='4'>
                    ���� 
                    <input type='text' name='rcon_day' size='3' value='<%=cls.getRcon_day()%>' class='whitenum' maxlength='4' onBlur='javascript:set_b_amt();'>
                  ��</td>
                     <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��&nbsp;</td>
                     <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">����� �������</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='dft_int' value='<%=cls.getDft_int_1()%>' size='5' class='whitenum' onBlur='javascript:set_b_amt()' maxlength='4'>
                  %</td>
                     <td >&nbsp;</td>
                  <td >=�ܿ��Ⱓ �뿩�� �Ѿ� ����</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">�ߵ����������(G)</td>
                  <td  align="center" width='25%' > 
                    <input type='text' name='dft_amt_1' size='15' class='whitenum' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��&nbsp;</td>
                  <td  align="center" >&nbsp;<%if(cls.getDft_amt_1() > 0 ){ if(cls.getTax_chk0().equals("Y")){%>���� <%} else {%>����� <% } } %> </td>
                  <td align="left"></td>
                </tr>
                         
                <tr> 
                 <td class="title" rowspan="6" width="5%"><br>
                    ��<br>
                    Ÿ</td> 
                  <td colspan="2" class="title">��ü��(H)</td>
                  <td align="center" width=25%> 
                    <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  �� </td>
                  <td  align="center">&nbsp;<%if(cls.getDly_amt_1() > 0 ){%>����� <% } %></td>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="2" class="title">����ȸ�����ֺ��(I)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='etc_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td  align="center">&nbsp;<%if(cls.getEtc_amt_1() > 0 ){ if (cls.getTax_chk1().equals("Y")){%>���� <%} else {%>����� <% } } %></td>
                  <td align="left"></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">����ȸ���δ���(J)</td>
                  <td width='25%' align="center"> 
                    <input type='text' name='etc2_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td  align="center">&nbsp;<%if(cls.getEtc2_amt_1() > 0 ){ if (cls.getTax_chk2().equals("Y")){%>���� <%} else {%>����� <% } } %></td>
                  <td align="left"></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">������������(K)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                   <td  align="center">&nbsp;<%if(cls.getEtc3_amt_1() > 0 ){ %>����� <% } %></td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">��Ÿ���ع���(L)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='etc4_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td align="center">&nbsp;<%if(cls.getEtc4_amt_1() > 0 ){ if (cls.getTax_chk3().equals("Y")){%>���� <%} else {%>����� <% } } %></td>
                  <td align="left"></td>
                </tr>
               <tr> 
                  <td colspan="2" class="title">�ʰ�����뿩��(M)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='over_amt_1' value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td align="center">&nbsp;<%if(cls.getOver_amt_1() > 0 ){ if(cls.getTax_chk4().equals("Y")){%>���� <%} else {%>����� <% } }%></td>
                  <td align="left"></td>
                </tr>
                
                <tr> 
                  <td colspan="3" class="title">�ΰ���(N)</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  �� </td>
                     <td >&nbsp;</td>
                  <td width='35%' >=(F+M-B-C)��10%</td>     
                </tr>
                <tr> 
                  <td class="title" colspan="4">��</td>
                  <td  align="center"> 
                    <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  �� </td>
                     <td >&nbsp;</td>
                  <td width='35%' >=(D+E+F+G+H+I+J+K+L+M+N)</td>
                </tr>
              </table>
            </td>
          </tr>
          
         <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ �����Ͻ� �ݾ�</span></td>
          </tr>
                
          <tr> 
            <td colspan="2" class="line"> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
 <%if( !cls.getCls_st().equals("���Կɼ�") ) {%>               
              
    <%if( cct.getJung_st().equals("2")   ) {%>
     		<tr> 
                  <td class='title' width="30%">��ȯ�ұݾ�</td>
                  <td width="25%" align="center"> 
                    <input type='text' readonly   name=h5_amt' value='<%=AddUtil.parseDecimal(cct.getH5_amt())%>'size='15' class='whitenum' maxlength='15'>
                  �� </td>
                  <td ' width="45%"></td>
                </tr>
                	<tr> 
                  <td class='title' width="30%">��û���ݾ�</td>
                  <td  width="25%" align="center"> 
                    <input type='text' readonly   name='h7_amt' value='<%=AddUtil.parseDecimal(cct.getH7_amt())%>'size='15' class='whitenum' maxlength='15'>
                  �� </td>
                  <td  width="45%"><%if(cls.getCms_chk().equals("Y")){%>( CMS �����Ƿ� )<% } %> </td>
                </tr>
    
    <%} else if( cct.getJung_st().equals("3")   ) {%>
     		<tr> 
                  <td class='title' width="30%"> ī�� ��ұݾ�</td>
                  <td width="25%" align="center"> 
                    <input type='text' readonly   name='h5_amt' value='<%=AddUtil.parseDecimal(cct.getH5_amt())%>'size='15' class='whitenum' maxlength='15'>
                  �� </td>
                  <td ' width="45%"></td>
                </tr>
                	<tr> 
                  <td class='title' width="30%"> ī�� �����ݾ�</td>
                  <td  width="25%" align="center"> 
                    <input type='text' readonly   name='h7_amt' value='<%=AddUtil.parseDecimal(cct.getH7_amt())%>'size='15' class='whitenum' maxlength='15'>
                  �� </td>
                  <td  width="45%">&nbsp;</td>
                </tr>
    
    <% } else { %>                   
                <tr> 
                  <td class='title' width="30%">�����Աݾ�</td>
                  <td  width="25%" align="center"> 
                    <input type='text' readonly   name='fdft_amt2' value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>'size='15' class='whitenum' maxlength='15'>
                  �� </td>
                  <td  width="45%"> =�̳��Աݾװ�-ȯ�ұݾװ� <%if(cls.getCms_chk().equals("Y")){%>( CMS �����Ƿ� )<% } %> </td>
                </tr>
       <% } %>             
  <%} %>  <!--  ���Կɼ��� �ƴ� ��� -->                            
              
                <tr id=tr_sale <%if( !cls.getCls_st().equals("���Կɼ�") ) {%> style='display:none;'<%}%>>                  
		    	  <td class='title' width="30%">���Կɼǽ� �����Աݾ�</td>
                  <td  width="25%" align="center"> 
                    <input type='text' name='fdft_amt3' value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>'size='15' class='whitenum' maxlength='15'>
                  �� </td>
                  <td width="45%">
     				   <% if ( clsm.getSui_d1_amt()    > 0 ) { %>=���Կɼǰ�+�̳��Աݾװ�-ȯ�ұݾװ�+������Ϻ��(�߻��� ���)
       			   <% } else {%>=���Կɼǰ�+�̳��Աݾװ�-ȯ�ұݾװ�
                   <% } %>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          
           <%  //���Կɼ��ΰ�츸 
	      if ( cls.getCls_st().equals("���Կɼ�") ) {
	    //	 System.out.println("status = " + clsm.getStatus());
	    	 if ( !clsm.getStatus().equals("0") ) {  
	    		 maeip_amt =  clsm.getM_dae_amt();
	    		 m_ext_amt =  clsm.getExt_amt();
	    	 }  else { //���� ������ 
		    	 if (cls.getFdft_amt2() < 0) {  
			 		   maeip_amt = cls.getFdft_amt2()* (-1);
					 
					   if (maeip_amt > cls.getOpt_amt() ) {
						    maeip_amt = cls.getOpt_amt();						  
					   }  				    	
			     }
	    	 
		    	 if (cls.getFdft_amt3() < 0) {  
		    	    m_ext_amt  = (cls.getFdft_amt3() * (-1)) + maeip_amt + cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2() - cls.getOpt_amt() - clsm.getSui_d_amt() ;	
	    	  //   } else {
	    	  //  	m_ext_amt  = maeip_amt +cls.getOpt_ip_amt2()  + cls.getOpt_ip_amt1() - cls.getOpt_amt() - cls.getSui_d_amt() ;	
	    	     } 	    	  
		    
		     }
		    
		   }   
	   %> 
	   
          <%if( cls.getCls_st().equals("���Կɼ�") ) {%> 
           <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կɼ� �Ա�</span></td>
          </tr> 
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                       
		          <tr> 
		                  <td class='title' width="30%">��ü�Ա�</td>
		                  <td  width="25%" align="center"> 
		                    <input type='text' name='m_dae_amt'   value='<%=AddUtil.parseDecimal(maeip_amt)%>' size='15' class='whitenum' maxlength='15'>
		                  �� </td>
		                  <td  width="45%"></td>
		                </tr>
		          
		           <tr> 
		                  <td class='title' width="30%">�����Ա�</td>
		                  <td  width="25%" align="center"> 
		                   <input type='text' name='i_dae_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2())%>'  size='15' class='whitenum' maxlength='15'>
		                  �� </td>
		                  <td  width="45%"> <%if(cls.getExt_st().equals("1")) { %>=��ȯ��  <%=AddUtil.parseDecimal(m_ext_amt)%> �� <% } %>  </td>
		                </tr>
               </table>
            </td>
           </tr>    
                      
           <% } %>
          
          <tr>
          
          <%	//���ຸ������
				ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString( fee_size) );%>
          <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� ����</span></td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%"> 
                    <%if(gins.getGi_amt() > 0){%>
                    ���� 
                    <%}else{%>
                    �̰��� 
                    <%}%>
                  </td>
                  <td  width="25%" align="center"> 
                    <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='whitenum' maxlength='15'>
                    ��</td>
                  <td width="45%"></td>
                </tr>
              </table>
            </td>
          </tr>
         </table>
      </td>
    </tr>
    
    <tr> 
      <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Աݰ���</span>&nbsp;&nbsp;&nbsp;* �������� 140-004-023871 (��)�Ƹ���ī</td>
    </tr>
        
    <!-- �ߵ����Կɼ��ΰ��-->
     
  <%if ( clsa.getOld_opt_amt()  >  0  &&   fee_size  ==  1 ) {%>   
  <!-- ������ ������ ��� -->  
 <!-- <p style='page-break-before:always'><br style="height:0; line-height:0"></P> -->
     
    <tr> 
      <td colspan="2" class="a4">&nbsp; </td>
    </tr>    
    <tr>    
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
         <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ߵ� ���꼭</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
        </tr> 	 	 	 	
 	 	  <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  rowspan="2"  width='4%'>ȸ��</td>
              <td class="title"  rowspan="2" width='10%'>�����ҳ�¥</td>                
       <!--       <td class="title"  rowspan="2" width='9%'>���뿩��<br>(���ް�)</td> -->
              <td class="title"  rowspan="2" width='9%'>������ ����ȿ�� �ݿ���<br> ���뿩��(���ް�)</td> 
              <td class="title"  rowspan="2" width='8%'>�ڵ�����</td>               
              <td class="title"  rowspan="2" width='8%'>�����+<br>������</td>
              <td class="title"  rowspan="2" width='10%'>�ڵ�����,�����+������ <br> ���ܿ��<br>(���ް�)</td>                
              <td class="title"  width='30%' colspan=3>�ڵ�����,����� ���ܿ���� ���簡ġ</td>             
              <td class="title"  width='20%' colspan=2>���簡ġ ���� �����ڷ�<br>(������: �� <%=clsa.getA_f()%>%)</td>             
            </tr>          
            
            <tr> 
              <td class="title"  width='10%' >���ް�</td>
              <td class="title"  width='10%'>�ΰ���</td>
              <td class="title"  width='10%'>�հ�</td>
              <td class="title"  width='8%'>����<br>��ġ��</td>
              <td class="title"  width='10%'>�����ϴ��<br>����ϼ�</td>
             </tr>  
             <tr> 
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td align="center"> (1) </td>
              <td align="center"> (2) </td>
              <td align="center"> (3) </td>
              <td align="center"> (4) = (1)-(2)-(3)</td>
              <td align="center"> (5) = (4) * (8) </td>
              <td align="center"> (6) = (5) * 0.1</td>
              <td align="center"> (7) = (5) + (6)</td>
              <td align="center"> (8) </td>
              <td align="center"> (9) </td>                          
             </tr>              
                           
<%	
		
	int t_s_grt_amt = 0;       
	int t_s_g_fee_amt = 0;       	
	int t_fee_s_amt = 0;            
	int t_s_cal_amt = 0;
	int t_r_fee_s_amt = 0;
	int t_r_fee_v_amt = 0;
	int t_r_fee_amt = 0;
	int  s_tax_is_amt = 0;
	int  s_g_fee_amt = 0;
	
					
	for(int i = 0 ; i < vt_size8 ; i++){
					Hashtable ht8 = (Hashtable)vts8.elementAt(i); 					
										
					t_s_grt_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_GRT_AMT")));
				
					t_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT")));
					t_s_cal_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_CAL_AMT")));
					t_r_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_S_AMT")));
					t_r_fee_v_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_V_AMT")));
					t_r_fee_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_AMT")));
					
					s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_G_FEE_AMT"))) ;
					if ( s_g_fee_amt < 1) s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT"))) ;			
					t_s_g_fee_amt += s_g_fee_amt;		
										
					s_tax_is_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_TAX_AMT"))) + AddUtil.parseInt(String.valueOf(ht8.get("S_IS_AMT")));
					
%>       
	 		   <tr>
                    <td>&nbsp;<%=ht8.get("S_FEE_TM")%> </td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht8.get("S_R_FEE_EST_DT")))%> </td>
              <!--       <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_FEE_S_AMT")))%></td> -->
                    <td align=right>&nbsp;<%=Util.parseDecimal(s_g_fee_amt)%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_TAX_AMT")))%> </td>   
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_IS_AMT")))%> </td>   
               <!--        <td align=right>&nbsp;<%=Util.parseDecimal(s_tax_is_amt)%> </td> -->             
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_AMT")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_S_AMT")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_V_AMT")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_AMT")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseFloat(String.valueOf(ht8.get("S_RC_RATE")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_DAYS")))%></td>
                   
               </tr>
<% } %>
               
               <tr>
                    <td colspan="2" class=title>�հ�</td>
             <!--       <td class=title><%=Util.parseDecimal(t_fee_s_amt)%></td> -->
                    <td class=title><%=Util.parseDecimal(t_s_g_fee_amt)%></td>
                    <td class=title></td>
                      <td class=title></td>
                    <td class=title><%=Util.parseDecimal(t_s_cal_amt)%></td>
                    <td class=title><%=Util.parseDecimal(t_r_fee_s_amt)%></td>
                    <td class=title><%=Util.parseDecimal(t_r_fee_v_amt)%></td>
                    <td class=title><%=Util.parseDecimal(t_r_fee_amt)%></td>
                    <td class=title></td>
                    <td class=title></td>                   
                  
               </tr>	  
                   
             </table>
            </td>
         </tr>         
    	
     	</table>
      </td>	 
  </tr>	 
   	 	    
  <% } %> 

    <!-- �ʰ�����δ���� �ִ� ���  -->     
  
    <tr> 
      <td colspan="2" class="a4">&nbsp; </td>
    </tr>
    
    <%if ( co.getR_over_amt() >  0  &&  cls_st.equals("����Ʈ����")) {%>          
    <tr>           	
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ʰ����� �뿩��</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	 	 	
 	 	 <tr> 
 	      <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="3"  width='34%'>�׸�</td>
              <td class="title" width='24%'>����</td>                
              <td class="title" width='42%'>���</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>   
              <td class="title"  rowspan=3>��೻��</td>
              <td class="title" >���Ⱓ</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
              <td align="left" >&nbsp;���ʰ��Ⱓ</td>
             </tr>
              <tr> 
              <td class="title" >�����Ÿ� (��)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;
               <%if( cls.getCls_st_r().equals("14") ){%>����<%}else{%>�Ⱓ<%}%>
       
              </td>
             </tr>      
              <tr> 
              <td class="title" > �ܰ�(�δ��) (a)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>��</td>
               <td align="left" >&nbsp;=1km</td>
             </tr>           
            <tr> 
              <td class="title"  rowspan=3>�������</td>
              <td class="title" >�뿩�Ⱓ</td>
              <td align="center">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
              <td align="left" >&nbsp;�����뿩�Ⱓ</td>
             </tr>   
              <tr> 
              <td class="title" >�뿩�ϼ�(��)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='whitenum' > �� </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" >�����Ÿ�(�ѵ�)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7'  value='<%=AddUtil.parseDecimal(co.getCal_dist() )%>' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(��)x(��) / <% if ( cls.getCls_st().equals("����Ʈ����") ) {%>30<% } else {%>365 <% } %></td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>      
               <td class="title"  rowspan=3>����Ÿ�</td>
              <td class="title" >��������Ÿ���(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value='<%=AddUtil.parseDecimal(co.getFirst_dist() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;����(�� �ε����� ����Ÿ�) , ������ (��༭�� ��õ� ����Ÿ�)</td>
             </tr>   
             <tr> 
              <td class="title" >��������Ÿ���(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly value='<%=AddUtil.parseDecimal(co.getLast_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title" >�ǿ���Ÿ�(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly   value='<%=AddUtil.parseDecimal(co.getReal_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
              <tr> 
              <td class="title"  rowspan=3>�������</td>
              <td class="title" >�ʰ�����Ÿ�(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly   value='<%=AddUtil.parseDecimal(co.getOver_dist() )%>'   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title" >���񽺸��ϸ���</td>
              <td align="right" ><input type='text' name='add_dist' readonly value='<%=AddUtil.parseDecimal(co.getAdd_dist() )%>'      size='7' class='whitenum' > km</td>
                <td align="left" >&nbsp;</td>
             </tr>      
              <tr> 
              <td class="title" >�������(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly value='<%=AddUtil.parseDecimal(co.getJung_dist() )%>'      size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title" colspan=2 >����ݾ�(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getR_over_amt() )%>'     size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;=(a)x(b)</td>
             </tr>
              <tr> 
              <td class="title"   colspan=2 >����(i)</td>
              <td align="right"><input type='text' name='m_over_amt'  value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'     readonly  size='10'  class='whitenum'> ��</td>
              <td align="left" > </td>
             </tr>      
              <tr> 
              <td class="title"   colspan=2 >����(����)�ݾ�</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getJ_over_amt() )%>'     size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;=(h)-(i)</td>
             </tr>  
            </table>
           </td>
         </tr>  
       	</table>
      </td>	 
    </tr>	      
   <% } else if  ( co.getR_over_amt() !=  0  &&  !cls_st.equals("����Ʈ����")) {%> 
	     <tr>           	
	 	   <td> 
	    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
	          <tr> 
	 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ȯ��/�ʰ����� �뿩��</span></td>
	 	 	  </tr>
	 	 	  <tr>
	      		 <td class=line2></td>
	   		  </tr>
	 	 	 	 	
	 	 	  <tr> 
	 	      <td colspan="2" class='line'> 
	          <table border="0" cellspacing="1" cellpadding="0" width=100%>
	           <tr> 
	              <td class="title"  colspan="5"  width='34%'>�׸�</td>
	              <td class="title" width='24%'>����</td>                
	              <td class="title" width='42%'>���</td>
	            </tr>
	            <tr> 
	              <td class="title"  rowspan="7" >��<br>��<br>��<br>��</td>   
	              <td class="title"  rowspan=4>��<br>��</td>
	              <td class="title"  colspan=3>���Ⱓ</td>
	              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
	              <td align="left" >&nbsp;���ʰ��Ⱓ</td>
	             </tr>
	             <tr> 
	              <td class="title" rowspan=3>����<br>�Ÿ�<br>����</td>
	              <td class="title"  colspan=2>���������Ÿ� (��)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
	              <td align="left" >&nbsp;</td>
	             </tr>  
	             <tr> 
	              <td class="title" rowspan=2>�ܰ�<br>(1km) </td>
	              <td class="title" >ȯ�޴뿩�� (a1)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getRtn_run_amt() )%>��</td>
	              <td align="left" >&nbsp;�����Ÿ� ���Ͽ���</td>
	             </tr>            
	             <tr> 
	              <td class="title" >�ʰ�����뿩��(a2)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>��</td>
	               <td align="left" >&nbsp;�����Ÿ� �ʰ�����</td>
	            </tr> 
	             <tr> 
	              <td class="title"  rowspan=3>��<br>��</td>
	              <td class="title"  rowspan=2>�̿�<br>�Ⱓ</td>  
	              <td class="title"  colspan=2 >���̿�Ⱓ	</td>     
	              <td align="center">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
	              <td align="left" >&nbsp;�����뿩�Ⱓ</td>
	            </tr>   
	            <tr> 
	              <td class="title"  colspan=2 >���̿��ϼ�	(��)</td>
	              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='whitenum' > �� </td>
	              <td align="left" >&nbsp;</td>
	             </tr>
	             <tr> 
	              <td class="title"  colspan=3 >�����Ÿ�(�ѵ�)(c)</td>
	              <td align="right" ><input type='text' name='cal_dist' readonly   size='7'  value='<%=AddUtil.parseDecimal(co.getCal_dist() )%>' class='whitenum' > km</td>
	               <td align="left" >&nbsp;=(��)x(��) / 365</td>
	             </tr>
	             <tr> 
	              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>      
	              <td class="title"  rowspan=3>��<br>��</td>
	              <td class="title"  colspan=3 >��������Ÿ���(d)</td>
	             <td align="right" ><input type='text' name='first_dist' readonly  value='<%=AddUtil.parseDecimal(co.getFirst_dist() )%>'  size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;����(�� �ε����� ����Ÿ�) , ������ (��༭�� ��õ� ����Ÿ�)</td>
	             </tr>   
	             <tr> 
	              <td class="title"  colspan=3>��������Ÿ���(e)</td>
	              <td align="right" ><input type='text' name='last_dist' readonly value='<%=AddUtil.parseDecimal(co.getLast_dist() )%>'    size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;</td>
	             </tr>     
	              <tr> 
	              <td class="title"  colspan=3 >�ǿ���Ÿ�(f)</td>
	              <td align="right" ><input type='text' name='real_dist' readonly   value='<%=AddUtil.parseDecimal(co.getReal_dist() )%>'    size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;=(e)-(d) </td>
	             </tr>                          
	             <tr> 
	              <td class="title"  rowspan=3>��<br>��</td>
	              <td class="title"   colspan=3 >������ؿ���Ÿ�	(g)</td>
	              <td align="right" ><input type='text' name='over_dist' readonly   value='<%=AddUtil.parseDecimal(co.getOver_dist() )%>'   size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;=(f)-(c) </td>
	             </tr>
	              <tr> 
	              <td class="title"   colspan=3 >�⺻�����Ÿ�</td>
	             <% if (  AddUtil.parseInt(base.getRent_dt()) > 20220414 ) { %>             
	              <td align="right" >&nbsp;��1,000 km</td>
	            <% } else { %>
	              <td align="right" >&nbsp;1,000 km</td>
	            <% }  %>  
	                <td align="left" >&nbsp;<input type='hidden' name='add_dist'  value='<%=AddUtil.parseDecimal(co.getAdd_dist() )%>'   readonly> </td>
	             </tr>      
	             <tr> 
	              <td class="title"  colspan=3 >�뿩��������ؿ���Ÿ�	(b)</td>
	              <td align="right" ><input type='text' name='jung_dist' readonly value='<%=AddUtil.parseDecimal(co.getJung_dist() )%>'      size='7' class='whitenum' > km</td>
	                <% if (  AddUtil.parseInt(base.getRent_dt())  > 20220414 ) { %>  
	              <td align="left" >&nbsp;(g)�� ��1,000km �̳��̸� ������(0km) , (g)��  ��1,000km�� �ƴϸ� (g)���⺻�����Ÿ� </td>
	                <% } else { %>
	               <td align="left" >&nbsp;</td> 
	                <% }  %>             
	           
	             </tr>  
	             <tr> 
	              <td class="title"  rowspan=3>��<br>��<br>��</td>
	              <td class="title"  rowspan=2>��<br>��</td>
	              <td class="title"  colspan=3 >����ݾ�(h)</td>
	              <td align="right" ><input type='text' name='r_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getR_over_amt() )%>'     size='10' class='whitenum' >��</td>
	              <td align="left" >&nbsp;(b)��  0km �̸��̸� (a1)*(b),<br>&nbsp;(b)�� 1km�̻��̸� (a2)*(b)</td>
	             </tr>
	             <tr> 
	              <td class="title"   colspan=3 >������(i)</td>
	              <td align="right"><input type='text' name='m_over_amt'  value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'   size='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> ��</td>
	              <td align="left" >&nbsp;</td>
	             </tr>      
	             <tr> 
	              <td class="title"  colspan=4 >����(�ΰ�/ȯ�޿���)�ݾ�</td>
	              <td align="right" ><input type='text' name='j_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getJ_over_amt() )%>'     size='10' class='whitenum' >��</td>
	              <td align="left" >&nbsp;=(h)-(i), ȯ��(-)</td>
	             </tr>    
            
	           </table>
	         </td>
	        </tr>  
	   	</table>
      </td>	 
    </tr>	   
  <% } %>                 
    
  </table>      
</form>

<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;		
			
		fm.c_amt.value 			= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value))   + toInt(parseDigit(fm.ex_ip_amt.value)) );
		fm.d_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		fm.dfee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
	   		
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
