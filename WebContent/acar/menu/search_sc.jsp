<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.cont.*, acar.client.*, acar.car_register.*, acar.debt.*, acar.insur.*"%>
<%@ page import="acar.common.*, acar.fee.*"%>
<jsp:useBean id="lr_db" scope="page" class="cust.rent.LongRentDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	
	String q_kd1 = request.getParameter("q_kd1")==null?"":request.getParameter("q_kd1");
	String q_kd2 = request.getParameter("q_kd2")==null?"2":request.getParameter("q_kd2");
	String q_wd = request.getParameter("q_wd")==null?"":request.getParameter("q_wd");//�˻���
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	
	//���:������
	Hashtable cont_view = lr_db.getLongRentCaseH(m_id, l_cd);
	//������
	ClientBean client = al_db.getClient(String.valueOf(cont_view.get("CLIENT_ID")));
	//��������
	ContCarBean car = a_db.getContCar(m_id, l_cd);
	//��������
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(c_id);
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	/* ���Ż��� ���� */
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	//car_etc
	ContBaseBean base = a_db.getContBaseAll(m_id, l_cd);
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgr(m_id, l_cd);
	int mgr_size = car_mgrs.size();	
	//�뿩����
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, "1");
	//����� ���� Y �� ���, ��������� ��ȸ
	Vector taec = a_db.getContTaecha(m_id,l_cd);
	int taec_size =taec.size();
	//�����������
	int ext_cnt = af_db.getMaxRentSt(m_id,l_cd);
	//�Һ�����
	ContDebtBean debt = ad_db.getContDebtReg(m_id, l_cd);
	//����������
	CltrBean cltr = ad_db.getBankLend_mapping_cltr(m_id, l_cd);
	//��������
	InsDatabase ai_db = InsDatabase.getInstance();
	String ins_st = ai_db.getInsSt(c_id);
	acar.insur.InsurBean ins = ai_db.getInsCase(c_id, ins_st);
%> 

<html>
<head>
<title>:: �����˻� ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
/*	function search(){
		var fm = document.form1;	
		fm.submit();
	}
	*/
	function enter(q_kd2) {
		var fm = document.form1;
		fm.q_kd2.value = q_kd2;
		if(q_kd2 == '1')		fm.q_wd.value = fm.firm_nm.value;
		else if(q_kd2 == '2')	fm.q_wd.value = fm.car_no.value;
		var keyValue = event.keyCode;
		if (keyValue =='13') fm.submit();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='search_sh.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="q_kd2" value='<%=q_kd2%>'>
<input type='hidden' name="q_wd" value='<%=q_wd%>'>
  <table width="830" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="750"> 
        <table width="750" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td colspan="3">&lt; ��� &gt; </td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">����ȣ</td>
                  <td width="110"><%=l_cd%></td>
                  <td class=title width="70">�������</td>
                  <td width="110"><%=cont_view.get("RENT_DT")%></td>
                  <td class=title width="70">��౸��</td>
                  <td width="110">
                    <%if(String.valueOf(cont_view.get("RENT_ST")).equals("1")){%>
                    �ű� 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("3")){%>
                    ���� 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("4")){%>
                    ���� 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("5")){%>
                    ����(12�����̸�) 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("2")){%>
                    ����(12�����̻�) 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("6")){%>
                    ������(6�����̻�) 					
                    <%}%>				  
				  </td>
                  <td class=title width="70">��������</td>
                  <td>
                    <%if(String.valueOf(cont_view.get("CAR_ST")).equals("1")){%>
                    ��ⷻƮ 
                    <%}else if(String.valueOf(cont_view.get("CAR_ST")).equals("2")){%>
                    ������ 
                    <%}else if(String.valueOf(cont_view.get("CAR_ST")).equals("3")){%>
                    �����÷��� 
                    <%}%>
                  </td>
                </tr>
                <tr> 
                  <td class=title>�뿩���</td>
                  <td><%=cont_view.get("RENT_WAY")%></td>
                  <td class=title>�뿩����</td>
                  <td><%=cont_view.get("CON_MON")%>����</td>
                  <td class=title>�뿩������</td>
                  <td><%=cont_view.get("RENT_START_DT")%></td>
                  <td class=title>�뿩������</td>
                  <td><%=cont_view.get("RENT_END_DT")%></td>
                </tr>
                <tr> 
                  <td class=title>������</td>
                  <td><%=c_db.getNameById(String.valueOf(cont_view.get("BRCH_ID")),"BRCH")%></td>
                  <td class=title>���ʿ�����</td>
                  <td><%=c_db.getNameById(String.valueOf(cont_view.get("BUS_ID")),"USER")%></td>
                  <td class=title>���������</td>
                  <td><%=c_db.getNameById(String.valueOf(cont_view.get("BUS_ID2")),"USER")%></td>
                  <td class=title>���������</td>
                  <td><%=c_db.getNameById(String.valueOf(cont_view.get("MNG_ID")),"USER")%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; �� &gt; </td>
          </tr>
          <tr> 
            <td class=line>
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">��ȣ</td>
                  <td width="180"> 
                    <input type="text" name="firm_nm" value="<%=cont_view.get("FIRM_NM")%>" size="25" class=text onKeyDown="javasript:enter('1')">
                  </td>
                  <td class=title width="70">��ǥ��</td>
                  <td width="160"><%=cont_view.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                  <td class=title>��뺻����</td>
                  <td colspan="3"><%=cont_view.get("R_SITE")%></td>
                </tr>
                <tr> 
                  <td class=title>�繫��</td>
                  <td><%= client.getO_tel()%></td>
                  <td class=title>�ѽ�</td>
                  <td><%= client.getFax()%></td>
                </tr>
              </table>
            </td>
            <td>&nbsp;</td>
            <td class=line>
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <%//���ΰ�����������
					if(mgr_size > 0){
						for(int i = 0 ; i < 3 ; i++){
							CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>			  
                <tr> 
                  <td class=title width="70"><%= mgr.getMgr_st()%></td>
                  <td width="200"><%= mgr.getMgr_nm()%>(<%= mgr.getMgr_tel()%>/<%= mgr.getMgr_m_tel()%>)</td>
                </tr>
                <%		}
					}%>				
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; �ڵ��� &gt; </td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">������ȣ</td>
                  <td width="110"> 
                    <input type="text" name="car_no" value="<%=cont_view.get("CAR_NO")%>" size="15" class=text onKeyDown="javasript:enter('2')">
                  </td>
                  <td class=title width="70">����</td>
                  <td colspan="5"><%=mst.getCar_nm()%>&nbsp;<%=mst.getCar_name()%></td>
                </tr>
                <tr> 
                  <td class=title>�������</td>
                  <td><%=base.getDlv_dt()%><%if(base.getDlv_dt().equals("")){%><%=pur.getDlv_con_dt()%>(����)<%}%></td>
                  <td class=title>�����ȣ</td>
                  <td width="120"><%=pur.getRpt_no()%></td>
                  <td class=title width="70">���ʵ����</td>
                  <td width="110"><%=cr_bean.getInit_reg_dt()%></td>
                  <td class=title width="70">�����ȣ</td>
                  <td><%=cr_bean.getCar_num()%></td>
                </tr>
                <tr> 
                  <td class=title>����</td>
                  <td>
				    <%if(cr_bean.getCar_ext().equals("1"))%>����<%%>
					<%if(cr_bean.getCar_ext().equals("2"))%>���<%%></td>
                  <td class=title>����</td>
                  <td>
                    <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>  					
				  </td>
                  <td class=title>��ⷮ</td>
                  <td><%=cr_bean.getDpm()%>cc</td>
                  <td class=title>����</td>
                  <td>
                    <%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%>                  	
				  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; �뿩 &gt; </td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
			  <%if(taec_size > 0){%>
				<%	for(int i = 0 ; i < taec_size ; i++){
						ContTaechaBean taecha = (ContTaechaBean)taec.elementAt(i);	
				%>			  
                <tr> 
                  <td class=title <%if(taec_size >1){%>rowspan=<%=taec_size%><%}%>>����</td>
                  <td class=title>�Ⱓ</td>
                  <td><%=taecha.getCar_rent_tm()%>����</td>
                  <td class=title>�뿩������</td>
                  <td><%=taecha.getCar_rent_st()%></td>
                  <td class=title>�뿩������</td>
                  <td><%=taecha.getCar_rent_et()%></td>
                  <td class=title>������ȣ</td>
                  <td><%=taecha.getCar_no()%></td>
                  <td class=title>����</td>
                  <td><%=c_db.getNameById(taecha.getCar_id(), "CAR_NM")%></td>
                </tr>
				<%	}%>
			  <%}%>				
                <tr> 
                  <td class=title rowspan="2">����</td>
                  <td class=title>�Ⱓ</td>
                  <td> 36����</td>
                  <td class=title width="70">�뿩������</td>
                  <td><%=fee.getRent_start_dt()%></td>
                  <td class=title width="70">�뿩������</td>
				  <%if(taec_size > 0){%>
                  <td><%=fee.getRent_end_dt()%></td>				  
                  <td class=title colspan="3">����������Ⱓ ���Կ���</td>
                  <td><%if(fee.getPrv_mon_yn().equals("0")){%>������<%}%><%else if(fee.getPrv_mon_yn().equals("1")){%>����<%}%></td>
				  <%}else{%>
                  <td colspan="5"><%=fee.getRent_end_dt()%></td>				  
				  <%}%>				  
                </tr>
                <tr> 
                  <td class=title>������</td>
                  <td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</td>
                  <td class=title>������</td>
                  <td><%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>��</td>
                  <td class=title>���ô뿩��</td>
                  <td><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��</td>
                  <td class=title>���뿩��</td>
                  <td><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��</td>
                  <td class=title>���Կɼ�</td>
                  <td><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>��/<%=fee.getOpt_per()%>%</td>
                </tr>
				<%if(ext_cnt > 1){%>
				<%	for(int i=1; i<ext_cnt; i++){
						ContFeeBean ext_fee = a_db.getContFee(m_id, l_cd, Integer.toString(i));%>
                <tr> 
                  <td class=title rowspan="2">����<br>
                    <%=i%></td>
                  <td class=title>�Ⱓ</td>
                  <td><%=ext_fee.getCon_mon()%>����</td>
                  <td class=title>�뿩������</td>
                  <td><%=ext_fee.getRent_start_dt()%></td>
                  <td class=title>�뿩������</td>
                  <td><%=ext_fee.getRent_end_dt()%></td>
                  <td class=title>�������</td>
                  <td ><%=c_db.getNameById(ext_fee.getExt_agnt(),"USER")%></td>
                  <td class=title>�������</td>
                  <td><%=ext_fee.getRent_dt()%></td>				  
                </tr>
                <tr> 
                  <td class=title>������</td>
                  <td><%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>��</td>
                  <td class=title>������</td>
                  <td><%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>��</td>
                  <td class=title>���ô뿩��</td>
                  <td><%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>��</td>
                  <td class=title>���뿩��</td>
                  <td colspan="3"><%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>��</td>
                </tr>
				<%	}%>
				<%}%>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; �Һ�/������ &gt;</td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">������</td>
                  <td width="90"><%=c_db.getNameById(debt.getCpt_cd(),"BANK")%></td>
                  <td class=title width="70">��������</td>
                  <td width="80"><%=debt.getLend_dt()%></td>
                  <td class=title width="70">����ݾ�</td>
                  <td width="80"><%=Util.parseDecimal(debt.getLend_prn())%>��</td>
                  <td class=title width="70">�����ȣ</td>
                  <td width="100"><%=debt.getLend_no()%></td>
                  <td class=title width="70">�Һ�Ƚ��</td>
                  <td width="50"><%=debt.getTot_alt_tm()%>ȸ</td>
                </tr>
                <tr> 
                  <td class=title>����������</td>
                  <td><%=Util.parseDecimal(cltr.getCltr_amt())%>��</td>
                  <td class=title>��������</td>
                  <td><%=cltr.getCltr_set_dt()%></td>
                  <td class=title>���ҵ����</td>
                  <td><%=cltr.getCltr_exp_dt()%></td>
                  <td class=title>���һ���</td>
                  <td colspan="3"><%=cltr.getCltr_exp_cau()%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; �ڵ������� &gt;</td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">�����</td>
                  <td width="90"><%=c_db.getNameById(ins.getIns_com_id(),"INS_COM")%></td>
                  <td class=title width="70">����Ⱓ</td>
                  <td width="150"><%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></td>
                  <td class=title width="70">���ɹ���</td>
                  <td width="70">
				    <%if(ins.getAge_scp().equals("1")){%>21���̻�<%}%> 
                	<%if(ins.getAge_scp().equals("2")){%>26���̻�<%}%> 
                	<%if(ins.getAge_scp().equals("3")){%>��������<%}%>
				  </td>
                  <td class=title width="60">�����</td>
                  <td width="60"><%if(ins.getAir_ds_yn().equals("Y") && ins.getAir_as_yn().equals("Y")){%>2��<%}else if(ins.getAir_ds_yn().equals("Y") && ins.getAir_as_yn().equals("N")){%>1��<%}%></td>
                  <td class=title  width="40">Ư��</td>
                  <td width="70"><%=ins.getVins_spe()%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td align="center" colspan="3"> 
              <hr>
            </td>
          </tr>
          <tr> 
            <td align="center" colspan="3">������ȣ�̷� || ����̷� || ���·��̷� || �����̷� || 
              ����̷� || �����̷� || ����ý����̷�</td>
          </tr>
        </table>
      </td>
      <td width="80" valign="top" align="right"> 
        <table width="70" border="1" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="63" align="center">&lt;�̵�&gt;</td>
          </tr>
          <tr> 
            <td width="63"><a href="#">������</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">�ڵ�������</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">������</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">�뿩��</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">������</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">���·�</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">��å��</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">��/������</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">�ߵ�����</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">�̼��ݰ���</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">�Һα�</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">�����</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">���޼�����</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">��Ÿ���</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">��������</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">���湮</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">���</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">����</a></td>
          </tr>
          <tr> 
            <td width="63">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="750">&nbsp;</td>
      <td width="50">&nbsp;</td>
    </tr>
  </table>
  </form>
</body>
</html>
<script language="JavaScript">
</script>