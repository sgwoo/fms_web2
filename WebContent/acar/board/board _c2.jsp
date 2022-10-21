<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.cls.*, acar.common.*, cust.rent.*, acar.car_mst.*"%>
<jsp:useBean id="lr_db" scope="page" class="cust.rent.LongRentDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String s_site = request.getParameter("s_site")==null?"":request.getParameter("s_site");
	String s_car_no = request.getParameter("s_car_no")==null?"":request.getParameter("s_car_no");
	String s_car_comp_id = request.getParameter("s_car_comp_id")==null?"":request.getParameter("s_car_comp_id");
	String s_car_cd = request.getParameter("s_car_cd")==null?"":request.getParameter("s_car_cd");
	String s_cls_st = request.getParameter("s_cls_st")==null?"":request.getParameter("s_cls_st");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	
	int rent_cnt = request.getParameter("rent_cnt")==null?0:AddUtil.parseInt(request.getParameter("rent_cnt"));	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//���:������
	Hashtable cont_view = lr_db.getLongRentCaseH(rent_mng_id, rent_l_cd);

	//��������
	ContCarBean car = a_db.getContCar(rent_mng_id, rent_l_cd);
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	//�⺻����
	Hashtable fee_base = af_db.getFeebasecls3(rent_mng_id, rent_l_cd);

	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
		
	int pp_amt = AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT"));
	
	//���̿�Ⱓ
	String mon_day = as_db.getMonDay((String)fee_base.get("RENT_START_DT"), cls.getCls_dt());
	String mon = "0";
	String day = "0";
	if(!mon_day.equals("")){
  	mon = mon_day.substring(0,mon_day.indexOf('/'));
  	day = mon_day.substring(mon_day.indexOf('/')+1);
  }  	
	if(mon.equals("")) mon="0";
	if(day.equals("")) day="0";	
 
 	String nbsp20 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����Ʈ ����	
	function go_to_list()
	{
		var fm = document.form1;
		var member_id = fm.member_id.value;
		var client_id = fm.client_id.value;			
		var r_site	= fm.r_site.value;								
		var auth_rw = fm.auth_rw.value;
		var s_yy 	= fm.s_yy.value;
		var s_mm 	= fm.s_mm.value;
		var s_dd 	= fm.s_dd.value;		
		var s_site 	= fm.s_site.value;
		var s_car_no= fm.s_car_no.value;
		var s_car_comp_id= fm.s_car_comp_id.value;
		var s_car_cd= fm.s_car_cd.value;
		var s_cls_st= fm.s_cls_st.value;		
		var rent_cnt= fm.rent_cnt.value;		
		var idx 	= fm.idx.value;	
		location = "l_rent_end_frame.jsp?member_id="+member_id+"&client_id="+client_id+"&r_site="+r_site+"&auth_rw="+auth_rw+"&s_yy="+s_yy+"&s_mm="+s_mm+"&s_dd="+s_dd+"&s_site="+s_site+"&s_car_no="+s_car_no+"&s_car_comp_id="+s_car_comp_id+"&s_car_cd="+s_car_cd+"&s_cls_st="+s_cls_st+"&rent_cnt="+rent_cnt+"&idx="+idx;
	}	
//-->
</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' action='l_rent_end_frame.jsp' target=''>
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_yy" value="<%=s_yy%>">
<input type='hidden' name="s_mm" value="<%=s_mm%>">
<input type='hidden' name="s_dd" value="<%=s_dd%>">
<input type='hidden' name="s_site" value="<%=s_site%>">
<input type='hidden' name="s_car_no" value="<%=s_car_no%>">
<input type='hidden' name="s_car_comp_id" value="<%=s_car_comp_id%>">
<input type='hidden' name="s_car_cd" value="<%=s_car_cd%>">
<input type='hidden' name="s_cls_st" value="<%=s_cls_st%>">
<input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
<input type='hidden' name="car_mng_id" value="<%=car_mng_id%>">
<input type='hidden' name="rent_cnt" value="<%=rent_cnt%>">
<input type='hidden' name="idx" value="<%=idx%>">
<!-- ������� -->
  <table border='0' cellspacing='0' cellpadding='0' width='800'>
    <tr> 
      <td colspan="2"> 
        <table width='800' cellpadding="0" cellspacing="0">
          <tr> 
            <td align='left'><font color="navy">������-> ���뿩</font> -> <font color="red">������� 
              �󼼳���</font> </td>
          </tr>
          <tr> 
            <td align='right'><a href='javascript:go_to_list();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
          </tr>
          <tr> 
            <td class=line> 
              <table border="0" cellspacing="1" cellpadding='0' width=800>
                <tr> 
                  <td class=title width="100">��������</td>
                  <td width="160">&nbsp; 
                    <%if(String.valueOf(cont_view.get("CLS_ST")).equals("1")){%>
                    ��ุ�� 
                    <%}else if(String.valueOf(cont_view.get("CLS_ST")).equals("2")){%>
                    �ߵ����� 
                    <%}else if(String.valueOf(cont_view.get("CLS_ST")).equals("8")){%>
                    ���Կɼ� 
                    <%}%>
                  </td>
                  <td class=title width="100">��������</td>
                  <td colspan="3">&nbsp;<%=cont_view.get("CLS_DT")%></td>
                </tr>
                <tr> 
                  <td class=title width="100">������ȣ</td>
                  <td width="160">&nbsp;<%=cont_view.get("CAR_NO")%></td>
                  <td class=title width="100">����</td>
                  <td colspan="3">&nbsp;<%=mst.getCar_nm()%>&nbsp;<%=mst.getCar_name()%></td>
                </tr>
                <tr> 
                  <td class=title>����ȣ</td>
                  <td>&nbsp;<%=rent_l_cd%></td>
                  <td class=title>�������</td>
                  <td width="160">&nbsp;<%=cont_view.get("RENT_DT")%></td>
                  <td class=title width="100">������</td>
                  <td width="180">&nbsp;<%=c_db.getNameById(String.valueOf(cont_view.get("BRCH_ID")),"BRCH")%></td>
                </tr>
                <tr> 
                  <td class=title>��뺻����</td>
                  <td colspan="5">&nbsp;<%=cont_view.get("R_SITE")%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">�뿩����</td>
          </tr>
          <tr> 
            <td class=line> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class=title width="100">�뿩��ǰ</td>
                  <td class='' width="120">&nbsp; 
                    <%if(String.valueOf(cont_view.get("CAR_ST")).equals("1")){%>
                    ��ⷻƮ 
                    <%}else if(String.valueOf(cont_view.get("CAR_ST")).equals("2")){%>
                    ������ 
                    <%}else if(String.valueOf(cont_view.get("CAR_ST")).equals("3")){%>
                    �����÷��� 
                    <%}%>
                    <%=cont_view.get("RENT_WAY")%></td>
                  <td class='title' width="80">�뿩�Ⱓ</td>
                  <td class='' width="160">&nbsp;<%=cont_view.get("RENT_START_DT")%>~<%=cont_view.get("RENT_END_DT")%></td>
                  <td class=title width="80">�Ѵ뿩�Ⱓ</td>
                  <td class='' width="90">&nbsp;<%=fee_base.get("TOT_CON_MON")%>����</td>
                  <td class='title' width="80">���̿�Ⱓ</td>
                  <td class='' width="90">&nbsp;<%=mon%>����<%=day%>��</td>
                </tr>
                <tr> 
                  <td class=title>���뿩��</td>
                  <td>&nbsp; 
                    <%if(fee_base.get("RENT_ST").equals("1")){%>
                    <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
                    <%}else{%>
                    <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
                    <%}%>
                    ��</td>
                  <td class=title>������</td>
                  <td>&nbsp; 
                    <%if(fee_base.get("RENT_ST").equals("1")){%>
                    <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT")))%> 
                    <%}else{%>
                    <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_PP_AMT"))+AddUtil.parseInt((String)fee_base.get("EX_IFEE_AMT")))%> 
                    <%}%>
                    ��</td>
                  <td  class=title>���ô뿩��</td>
                  <td>&nbsp; 
                    <%if(fee_base.get("RENT_ST").equals("1")){%>
                    <%//=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT")))%>
                    <%=AddUtil.parseDecimal((String)fee_base.get("IFEE_AMT"))%> 
                    <%}else{%>
                    <%//=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_PP_AMT"))+AddUtil.parseInt((String)fee_base.get("EX_IFEE_AMT")))%>
                    <%=AddUtil.parseDecimal((String)fee_base.get("EX_IFEE_AMT"))%> 
                    <%}%>
                    ��</td>
                  <td  class=title>������</td>
                  <td>&nbsp; 
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
        </table>
    </tr>
  </table>
  <%if(String.valueOf(cont_view.get("CLS_ST")).equals("8")){%>  
  <table border='0' cellspacing='0' cellpadding='0' width='800'>
    <tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="0" cellpadding="0" width=800>
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">���Կɼ�</td>
          </tr>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class=title width="100">���Կɼ���</td>
                  <td class='' width="100">00%</td>
                  <td class='title' width="100">���Կɼǰ�</td>
                  <td class='' width="100">00��</td>
                  <td class=title width="100">��������</td>
                  <td class='' width="100">2004-04-02</td>
                  <td class='title' width="100">������ϴ����</td>
                  <td class='' width="100">������</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table> 
  <%}%> 
  <%if(String.valueOf(cont_view.get("CLS_ST")).equals("2") && cls.getCls_doc_yn().equals("Y") && !cls.getNo_dft_yn().equals("Y")){%>   
  <table border='0' cellspacing='0' cellpadding='0' width='800'>		
    <tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="0" cellpadding="0" width=800>
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">������</td>
          </tr>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width='200'>�׸�</td>
                  <td class='title' width='300'>����</td>
                  <td class='title' width="300">&nbsp;���</td>
                </tr>
                <tr> 
                  <td align="center" height="17">������</td>
                  <td align="right" height="17"><%if(cls.getGrt_amt() > 0){%><%=AddUtil.parseDecimal(cls.getGrt_amt())%><%}else{%><%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("GRT_AMT")))%><%}%>��<%=nbsp20%></td>
                  <td class='' height="17">&nbsp;</td>
                </tr>
                <input type='hidden' name='t_mpp_amt2' value=''>
                <!--�ʱⳳ�Ա�-->
                <input type='hidden' name='h_opt_chk2' value='1'>
                <!--���Կɼ�üũ-->
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="0" cellpadding="0" width=800>
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">�ܿ�������</td>
            <td align="right"><!--[���ް�]--></td>
          </tr>
          <tr> 
            <td class='line' colspan="2"> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width='200'>�׸�</td>
                  <td class='title' width='300'>����</td>
                  <td class='title' width="300">&nbsp;���</td>
                </tr>
                <tr> 
                  <td align="center">������</td>
                  <td align="right"><%=AddUtil.parseDecimal(pp_amt)%>��<%=nbsp20%></td>
                  <td class=''>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">������ ��������</td>
                  <td align="right"><%=AddUtil.parseDecimal(cls.getPded_s_amt()+cls.getPded_v_amt())%>��<%=nbsp20%></td>
                  <td class=''>=������/���Ⱓ</td>
                </tr>
                <tr> 
                  <td align="center">������ �����Ѿ�</td>
                  <td align="right"><%=AddUtil.parseDecimal(cls.getTpded_s_amt()+cls.getTpded_v_amt())%>��<%=nbsp20%></td>
                  <td class=''>=��������*���̿�Ⱓ</td>
                </tr>
                <tr> 
                  <td class='title' align="center">�ܿ� ������</td>
                  <td align="right"><%=AddUtil.parseDecimal(cls.getRfee_s_amt()+cls.getRfee_v_amt())%>��<%=nbsp20%></td>
                  <td class=''>&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">�̳� ���뿩��</td>
            <td align="right">
              <!--[���ް�]-->
            </td>
          </tr>
          <tr> 
            <td class='line' colspan="2"> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width='200'>�׸�</td>
                  <td class='title' width='300' colspan="2">����</td>
                  <td class='title' width="300">&nbsp;���</td>
                </tr>
                <tr> 
                  <td align="center">���뿩��</td>
                  <td align="right" colspan="2"><%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%>��<%=nbsp20%></td>
                  <td class=''>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">�뿩�� �̳� �̿�Ⱓ</td>
                  <td align="center" width="150"><%=cls.getNfee_mon()%>����</td>
                  <td align="center" width="150"><%=cls.getNfee_day()%>��</td>
                  <td class=''>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' align="center">�̳� ���뿩�� ��</td>
                  <td align="right" colspan="2"><%=AddUtil.parseDecimal(cls.getNfee_amt())%>��<%=nbsp20%></td>
                  <td class=''>&nbsp;</td>
                </tr>
                <input type='hidden' name='t_mpp_amt22' value=''>
                <!--�ʱⳳ�Ա�-->
                <input type='hidden' name='h_opt_chk22' value='1'>
                <!--���Կɼ�üũ-->
              </table>
            </td>
          </tr>
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">�ߵ����� 
              �����</td>
            <td align="right">
              <!--[���ް�]-->
            </td>
          </tr>
          <tr> 
            <td class='line' colspan="2"> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width='200'>�׸�</td>
                  <td class='title' width='300' colspan="2">����</td>
                  <td class='title' width="300">&nbsp;���</td>
                </tr>
                <tr> 
                  <td align="center">�뿩�� �Ѿ�</td>
                  <td align="right" colspan="2"><%=AddUtil.parseDecimal(cls.getTfee_amt())%>��<%=nbsp20%></td>
                  <td class=''>=������+���뿩�� �Ѿ�</td>
                </tr>
                <tr> 
                  <td align="center">ȯ�� ����� �뿩��</td>
                  <td align="right" colspan="2"><%=AddUtil.parseDecimal(cls.getMfee_amt())%>��<%=nbsp20%></td>
                  <td class=''>=�뿩���Ѿ�/���Ⱓ</td>
                </tr>
                <tr> 
                  <td align="center">�ܿ� ���Ⱓ</td>
                  <td align="center" width="150"><%=cls.getRcon_mon()%>����</td>
                  <td align="center" width="150"><%=cls.getRcon_day()%>��</td>
                  <td class=''>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">�ܿ� ���Ⱓ �뿩�� �Ѿ�</td>
                  <td align="right" colspan="2"><%=AddUtil.parseDecimal(cls.getTrfee_amt())%>��<%=nbsp20%></td>
                  <td class=''>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">����� ������</td>
                  <td align="center" colspan="2"><%=cls.getDft_int()%>%</td>
                  <td class=''>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' align="center">�ߵ����� �����</td>
                  <td align="right" colspan="2"><%=AddUtil.parseDecimal(cls.getDft_amt())%>��<%=nbsp20%></td>
                  <td class=''>&nbsp;</td>
                </tr>
                <input type='hidden' name='t_mpp_amt22' value=''>
                <!--�ʱⳳ�Ա�-->
                <input type='hidden' name='h_opt_chk22' value='1'>
                <!--���Կɼ�üũ-->
              </table>
            </td>
          </tr>
		  <!--
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">�������ظ�å��</td>
            <td align="right">[���ް�]</td>
          </tr>
          <tr> 
            <td class='line' colspan="2"> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width='200'>���Բ��� �δ��Ͻ� �ݾ�</td>
                  <td width='300' align="right">��</td>
                  <td width="300">&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
		  -->
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">�ߵ����������</td>
            <td align="right">[�ΰ��� <%if(cls.getVat_st().equals("0")){%>������<%}else{%>����<%}%>]</td>
          </tr>
          <tr> 
            <td class='line' colspan="2"> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width='200'>���Բ��� �����Ͻ� �ݾ�</td>
                  <td width='300' align="right"><%=AddUtil.parseDecimal(cls.getFdft_amt1())%>��<%=nbsp20%></td>
                  <td width="300">=�̳��뿩���+�ߵ����������<!--+�������ظ�å��<br>&nbsp;-������-�ܿ�������--></td>
                </tr>
              </table>
            </td>
          </tr>
		  <!--
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">�̳��ΰ���</td>
            <td align="right">&nbsp;</td>
          </tr>
           <%	int fee_v_amt =0;
				//�뿩�������� ��ü����Ʈ
				Vector fee_scd = af_db.getFeeScdDly(rent_mng_id);
				int fee_scd_size = fee_scd.size();			   
			  	for(int i = 0 ; i < fee_scd_size ; i++){
		  			FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
					fee_v_amt = fee_v_amt+a_fee.getFee_v_amt();
              	}%>		  
          <tr> 
            <td class='line' colspan="2"> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width='200'>�̳� ���뿩�� �ΰ���</td>
                  <td width='300' align="right"><%=fee_v_amt%>��<%=nbsp20%></td>
                  <td width="300">���ݰ�꼭 �����</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td><img src="../../images/arrow2.gif" width="12" height="9">������ 
              �����Ͻ� �ݾ�</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td class='line' colspan="2"> 
              <table border="0" cellspacing="1" cellpadding="0" width=800>
                <tr> 
                  <td class='title' width='200'>�Ѿ�</td>
                  <td width='300' align="right">��<%=nbsp20%></td>
                  <td width="300">=�ߵ����������+�̳��ΰ���</td>
                </tr>
              </table>
            </td>
          </tr>
				-->		  
          <tr align="right"> 
            <td colspan="2"><a href='javascript:go_to_list();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>  
  <%}%> 
</form>
<script language='javascript'>
<!--
	
-->
</script>
</body>
</html>

