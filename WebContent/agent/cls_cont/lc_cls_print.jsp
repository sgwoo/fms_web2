<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.credit.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
		
	//�˻�����
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	
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
	
	int pp_amt = AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT"));
	

//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_p.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//�����ݾ����� ����
	function set_a_amt(){
		var fm = document.form1;	
			
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
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
		fm.fdft_amt1_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) );
		set_cls_amt();
	}	
				
	//�������Ͻ� �ݾ� ����
	function set_cls_amt(){
		var fm = document.form1;	
		
		fm.fdft_amt2.value 		= 	parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );			
	}	
	
	//�����
		
//-->
</script>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 10.0; //��������   
		factory.printing.rightMargin 	= 10.0; //��������
		factory.printing.topMargin 	= 5.0; //��ܿ���    
		factory.printing.bottomMargin 	= 5.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
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
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=650>
    <tr align="center"> 
       <td colspan="2"><font color="#006600">&lt; ���뿩 <%=cls.getCls_st()%> ���꼭 &gt;</font></td>
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
              <%=cls.getCls_dt()%>
            </td>
            <td class='title' width="10%">�̿�Ⱓ</td>
            <td width="40%"> 
              <%=cls.getR_mon()%>
              ���� 
              <%=cls.getR_day()%>
              ��</td>
          </tr>
		
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
    </tr>	
    
    <!-- ���Կɼ��� ��� ���Կɼ� ���� ����  -->
    <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 

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
		             <td colspan=6>&nbsp;<%=AddUtil.parseDecimal(cls.getOpt_amt())%> ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT����)</td> 
		           
                  </tr>	
                                
		          <tr> 
		 	 	     <td class='title' width="13%" rowspan=3>������Ϻ��</td>
		             <td class='title' width="13%">��ϼ�</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d1_amt())%> �� 
		             <td class='title' width="13%">ä������</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d2_amt())%> �� 
		             <td class='title' width="13%">��漼</td>
		             <td >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d3_amt())%> �� 
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">������</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d4_amt())%> ��
		             <td class='title' width="13%">������</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d5_amt())%> ��
		             <td class='title' width="13%">��ȣ�Ǵ�</td>
		             <td >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d6_amt())%> ��
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">������ȣ�Ǵ�</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d7_amt())%> ��
		             <td class='title' width="13%">��ϴ����</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d8_amt())%> ��
		             <td class='title' width="13%">��</td>
		             <td >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%> ��
		          </tr>  
		       </table>
		      </td>        
         </tr>   
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
                  <td class='title' width='35%' align="center">����</td>
                  <td class='title' width="35%">���</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="7">ȯ<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td class='title' colspan="2">������(A)</td>
                  <td width="35%" class='title' > 
                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    ��</td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td width="20%" align="center" >����Ⱓ</td>
                  <td width="35%" align="center"> 
                    <input type='text' size='3' name='ifee_mon' value='<%=cls.getIfee_mon()%>' class='num' maxlength='4' >
                    ����&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='ifee_day' value='<%=cls.getIfee_day()%>' class='num' maxlength='4' >
                    ��</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td width="20%" align="center">����ݾ�</td>
                  <td width="35%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    ��</td>
                  <td>=���ô뿩�᡿����Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ���ô뿩��(B)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    ��</td>
                  <td class='title'>=���ô뿩��-����ݾ�</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">��<br>
                    ��<br>
                    ��</td>
                  <td align='center' width="20%">�������� </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                  <td>=�����ݡ����Ⱓ</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">������ �����Ѿ� </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    ��</td>
                  <td>=�������ס����̿�Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">�ܿ� ������(C)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��</td>
                  <td class='title'>=������-������ �����Ѿ�</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">��</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    ��</td>
                  <td class='title'>=(A+B+C)</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">�߰��Աݾ�</td>
                  <td  width='35%' align="center" class='title' > 
                    <input type='text' name='ex_ip_amt' value='<%=AddUtil.parseDecimal(clsm.getEx_ip_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    ��</td>
                  <td >=�߰��Աݾ��� �ִ� ���</td>
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
                  <td class="title" width='35%'> ����</td>
                  <td class="title" width='35%'>���</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="18" width="5%">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td colspan="3" class="title">���·�/��Ģ��(D)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fine_amt_1' value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td class='title' >&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="3" class="title">�ڱ��������ظ�å��(E)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='car_ja_amt_1' value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    �� </td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                   <td class="title" rowspan="4" width="5%"><br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">������</td>
                  <td align="center">&nbsp; 
                    <input type='text' name='ex_di_amt_1' value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                  ��&nbsp; </td>
                  <td >&nbsp; </td>
                </tr>
                <tr> 
                  <td rowspan="2" align="center" width="10%">�̳���</td>
                  <td width='10%' align="center">�Ⱓ</td>
                  <td align="center"> &nbsp; 
                    <input type='text' size='4' name='nfee_mon' value='<%=cls.getNfee_mon()%>' class='num' maxlength='4'>
                    ���� 
                    <input type='text' size='4' name='nfee_day' value='<%=cls.getNfee_day()%>' class='num'  maxlength='4'>
                  ��</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">�ݾ�</td>
                  <td align="center"> 
                    <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��</td>
                  <td >���� ���ݰ�꼭 ����</td>
                </tr>
                
                <tr> 
                  <td class="title" colspan="2">�Ұ�(F)</td>
                  <td class='title' align="center">
                    <input type='text' name='dfee_amt' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' onBlur='javascript:this.value=parseDecimal(this.value); '>
                  �� </td>
                  <td class='title' >&nbsp;</td>
                </tr>
                 <input type='hidden' name='d_amt' size='15' class='whitenum' >
                <tr> 
                  <td rowspan="6" class="title">��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��<br>
                    ��</td>
                  <td align="center" colspan="2">�뿩���Ѿ�</td>
                  <td align="center"> 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��</td>
                  <td >=������+���뿩���Ѿ�</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">���뿩��(ȯ��)</td>
                  <td align="center"> 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��</td>
                  <td >=�뿩���Ѿס����Ⱓ</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��뿩���Ⱓ</td>
                  <td align="center"> 
                    <input type='text' name='rcon_mon' size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4'>
                    ���� 
                    <input type='text' name='rcon_day' size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' onBlur='javascript:set_b_amt();'>
                  ��</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
                  <td align="center"> 
                    <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">����� �������</td>
                  <td align="center"> 
                    <input type='text' name='dft_int' value='<%=cls.getDft_int()%>' size='5' class='num' onBlur='javascript:set_b_amt()' maxlength='4'>
                  %</td>
                  <td >�ܿ��Ⱓ �뿩�� �Ѿ� ����</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">�ߵ����������(G)</td>
                  <td class='title' align="center"> 
                    <input type='text' name='dft_amt_1' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��&nbsp;</td>
                  <td align="left"><%if(cls.getTax_chk0().equals("Y")){%>����� ��꼭 ����<%}%></td>
                </tr>
                         
                <tr> 
                 <td class="title" rowspan="5" width="5%"><br>
                    ��<br>
                    Ÿ</td> 
                
                  <td colspan="2" class="title">��ü��(H)</td>
                  <td align="center" width=20%> 
                    <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  �� </td>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="2" class="title">����ȸ�����ֺ��(I)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td align="left"><%if(cls.getTax_chk1().equals("Y")){%>����ȸ�����ֺ�� ��꼭 ����<%}%></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">����ȸ���δ���(J)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc2_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td align="left"><%if(cls.getTax_chk2().equals("Y")){%>����ȸ���δ��� ��꼭 ����<%}%></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">������������(K)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">��Ÿ���ع���(L)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc4_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    �� </td>
                  <td align="left"><%if(cls.getTax_chk3().equals("Y")){%>��Ÿ���ع��� ��꼭 ����<%}%></td>
                </tr>
              
                <tr> 
                  <td colspan="3" class="title">�ΰ���(M)</td>
                  <td class='title' align="center"> 
                    <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  �� </td>
                  <td class='title' width='35%' >
                  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style="display:''" class='title'>=(�̳��Աݾ�-B-C)��10% + ��꼭 ����ΰ���
                        </td>
                        <td id=td_cancel_y style='display:none' class='title'>=(�̳��Աݾ�-B-C)��10% + ��꼭 ����ΰ���
                        </td>
                      </tr>
                      </table>
                    </td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">��</td>
                  <td class='title' align="center"> 
                    <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  �� </td>
                  <td class='title' width='35%' >=(D+E+F+G+H+I+J+K+L+M)</td>
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
                <tr> 
                  <td class='title' width="30%">�����Աݾ�</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt2' value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>'size='15' class='num' maxlength='15'>
                  �� </td>
                  <td class='title' width="35%"> =�̳��Աݾװ�-ȯ�ұݾװ�</td>
                </tr>
                <tr id=tr_sale style="display:<%if( cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 
                 
		    	  <td class='title' width="30%">���Կɼǽ� �����Աݾ�</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt3' value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>'size='15' class='num' maxlength='15'>
                  �� </td>
                  <td class='title' width="35%"> =�����Աݾ�+�����Ű��ݾ�+������Ϻ��(�߻��� ���)</td>			
                </tr>
              </table>
            </td>
          </tr>
          <%	//���ຸ������
				ContGiInsBean gins = a_db.getContGiIns(rent_mng_id, rent_l_cd);%>
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
                    ���� 
                    <%}%>
                  </td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' maxlength='15'>
                    ��</td>
                  <td class='title' width="35%"></td>
                </tr>
              </table>
            </td>
          </tr>
         </table>
      </td>
    </tr>
      <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    
    <tr> 
      <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Աݰ���</span>&nbsp;&nbsp;&nbsp;* �������� 140-004-023871 (��)�Ƹ���ī</td>
    </tr>	

  </table>
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
		fm.d_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
