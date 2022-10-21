<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, cust.member.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	
	String rent_mng_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 		= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�׿��� �ŷ�ó ����
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable ven = new Hashtable();
	if(!client.getVen_code().equals("")){
		ven = neoe_db.getVendorCase(client.getVen_code());
	}
	
	//��FMS
	MemberBean m_bean = m_db.getMemberCase(base.getClient_id(), base.getR_site(), "");
	
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//��������
	String ins_st = "";
	String ins_com_nm = "";
	
	//�����������&����
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		
		ins_st 	= ai_db.getInsSt(base.getCar_mng_id());
		ins 	= ai_db.getIns(base.getCar_mng_id(), ins_st);
		ins_com_nm = ai_db.getInsComNm(base.getCar_mng_id());
	}
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�⺻��� ���� ����
	String car_b_inc_name = cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//����,�����
	Hashtable mgrs = a_db.getCommiNInfo(rent_mng_id, rent_l_cd);
	Hashtable mgr_bus = (Hashtable)mgrs.get("BUS");
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");
	
	//�ڵ���ü����
	ContCmsBean cms 	= a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	

%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border=0 cellspacing=0 cellpadding=0 width=780>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=7% style="font-size : 8pt;">����ȣ</td>
                    <td width=14%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=7% style="font-size : 8pt;">��������</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=7% style="font-size : 8pt;">��������</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                    <td class=title width=7% style="font-size : 8pt;">���ʿ���</td>
                    <td width=8%>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title width=7% style="font-size : 8pt;">�������</td>
                    <td width=8%>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                    <td class=title width=7% style="font-size : 8pt;">�������</td>
                    <td width=8%>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">�������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title style="font-size : 8pt;">��౸��</td>
                    <td>&nbsp;<%if(base.getRent_st().equals("1")){%>�ű�<%}else if(base.getRent_st().equals("3")){%>����<%}else if(base.getRent_st().equals("4")){%>����<%}%></td>
                    <td class=title style="font-size : 8pt;">��������</td>
                    <td>&nbsp;<%if(base.getBus_st().equals("1")){%>���ͳ�<%}else if(base.getBus_st().equals("2")){%>�������<%}else if(base.getBus_st().equals("3")){%>��ü�Ұ�<%}else if(base.getBus_st().equals("4")){%>catalog<%}else if(base.getBus_st().equals("5")){%>��ȭ���<%}else if(base.getBus_st().equals("6")){%>������ü<%}else if(base.getBus_st().equals("7")){%>������Ʈ<%}else if(base.getBus_st().equals("8")){%>�����<%}%></td>
                    <td class=title style="font-size : 8pt;">��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                    <td class=title style="font-size : 8pt;">�뵵����</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
                    <td class=title style="font-size : 8pt;">��������</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td style='height:5'></td>
    </tr> 
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="10%" class='title' style="font-size : 8pt;">��ȣ/����</td>
        		    <td colspan="3">&nbsp;<b><font color='#990000'><%=client.getFirm_nm()%></font></b>&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getClient_nm()%><%}%></td>
                    <td width="10%" class='title' style="font-size : 8pt;"> ������ </td>
                    <td colspan="3">&nbsp; 
                      <%if(client.getClient_st().equals("1")) 		out.println("����");
                      	else if(client.getClient_st().equals("2"))  out.println("����");
                      	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
                      	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
                      	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");%>
                    </td>
                </tr>
    		    <%if(!client.getClient_st().equals("2")){%>
    		    <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">����ڹ�ȣ<br/></td>
        		    <td colspan="3">&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;"><%if(client.getClient_st().equals("1")){%>���ι�ȣ<%}else if(client.getClient_st().equals("2")){%>�������<%}else{%>�������<%}%></td>
        		    <td colspan="3">&nbsp;<%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
		        </tr>
		        <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">����</td>
        		    <td colspan="3"">&nbsp;<%=client.getBus_cdt()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">����</td>
        		    <td colspan="3">
        		        <table width=100% border=0 cellspacing=0 cellpadding=3>
        		            <tr>
        		                <td><%=client.getBus_itm()%></td>
        		            </tr>
        		        </table>
        		    </td>
		        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">����� �ּ�</td>
        		    <td colspan="7">&nbsp;<%if(!client.getO_addr().equals("")){%>(<%=client.getO_zip()%>)<%=client.getO_addr()%><%}%></td>
		        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;"><%if(client.getClient_st().equals("1")){%>���� ������<%}else{%>����� �ּ�<%}%></td>
        		    <td colspan="7">&nbsp;<%if(!client.getHo_addr().equals("")){%>(<%=client.getHo_zip()%>)<%=client.getHo_addr()%><%}%></td>
		        </tr>
		        <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">�޴�����ȣ</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">���ù�ȣ</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">�繫�ǹ�ȣ</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">�ѽ���ȣ</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
		        </tr>
		        <%}else{%>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">�������</td>
        		    <td colspan="3">&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
        		    <td class='title' style="font-size : 8pt;">�����ּ�</td>
        		    <td colspan="3" style="font-size : 8pt;">&nbsp;<%if(!client.getHo_addr().equals("")){%>(<%=client.getHo_zip()%>)<%=client.getHo_addr()%><%}%></td>
    		    </tr>
	            <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">�޴�����ȣ</td>
        		    <td width="15%" >&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">���ù�ȣ</td>
        		    <td width="15%" >&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">�����ȣ</td>
        		    <td width="15%" >&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">����FAX</td>
        		    <td width="15%" >&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
		        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">����</td>
        		    <td>&nbsp;<%=client.getJob()%></td>
        		    <td class='title' style="font-size : 8pt;">�ҵ汸��</td>
        		    <td>&nbsp;<%if(client.getPay_st().equals("1")) 		out.println("�޿��ҵ�");
        	              	else if(client.getPay_st().equals("2"))    out.println("����ҵ�");
        	               	else if(client.getPay_st().equals("3"))	out.println("��Ÿ����ҵ�");%></td>
        		    <td class='title' style="font-size : 8pt;">�ټӿ���</td>
        		    <td>&nbsp;<%=client.getWk_year()%>��</td>
        		    <td class='title' style="font-size : 8pt;">���ҵ�</td>
        		    <td>&nbsp;<%=client.getPay_type()%>����</td>
		        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">�����</td>
        		    <td>&nbsp;<%=client.getCom_nm()%></td>
        		    <td class='title' style="font-size : 8pt;">�μ�/����</td>
        		    <td>&nbsp;<%=client.getDept()%>/<%=client.getTitle()%></td>
        		    <td class='title' style="font-size : 8pt;">�����ּ�</td>
        		    <td colspan="3">&nbsp;<%if(!client.getComm_addr().equals("")){%>(<%=client.getComm_zip()%>)<%=client.getComm_addr()%><%}%></td>   
		        </tr>			
    		    <%}%>
                <tr>
                    <td class='title' style="font-size : 8pt;">���౸��</td>
                    <td>&nbsp;
                      <%if(client.getPrint_st().equals("1")) 		out.println("���Ǻ�");
                      	else if(client.getPrint_st().equals("2"))   out.println("�ŷ�ó����");
                      	else if(client.getPrint_st().equals("3")) 	out.println("��������");
                     	else if(client.getPrint_st().equals("4"))	out.println("��������");%></td>
                    <td class='title' style="font-size : 8pt;">��꼭���</td>
                    <td>&nbsp;<%if(!client.getBigo_yn().equals("Y")){%>��ǥ��<%}%></td>
                    <td class='title' style="font-size : 8pt;">�׿����ڵ�</td>
                    <td colspan="3">&nbsp;<%if(!client.getVen_code().equals("")){%>(<%=client.getVen_code()%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%></td>
		        </tr>
    		    <tr>
                    <td class='title' style="font-size : 7pt;">�ŷ���������</td>
                    <td colspan="3">&nbsp;<%  if(client.getItem_mail_yn().equals("N")) 		out.println("�ź�");
                      	else   										out.println("�¶�");
                     	%></td>		   
                    <td class='title' style="font-size : 7pt;">���ݰ�꼭����</td>
                    <td colspan="3">&nbsp;<%  if(client.getTax_mail_yn().equals("N")) 		out.println("�ź�");
                      	else   										out.println("�¶�");
                     	%></td>		   									
    		    <tr>
                    <td class='title' style="font-size : 8pt;">���ϰźλ���</td>
                    <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>		   
                    <td class='title' style="font-size : 8pt;">��ü���ڼ���</td>
                    <td colspan="3">&nbsp;<%  if(client.getDly_sms().equals("N")) 		out.println("�ź�");
                      	else   										out.println("�¶�");
                     	%></td>		   					
                </tr>				
		        <%if(!client.getEtc().equals("")){%>
		        <tr>
                    <td class='title' style="font-size : 8pt;"> Ư�̻��� </td>
                    <td colspan="7">
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td><%=Util.htmlBR(client.getEtc())%></td>	
                            </tr>
                        </table>
                    </td>	  
                </tr>
		        <%}%>
            </table>
        </td>
	</tr>    
  <%if(!site.getR_site().equals("")){%>
  <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
        		    <td class='title' style="font-size : 8pt;">��ȣ/����</td>
        		    <td colspan='3'>&nbsp;<b><%=site.getR_site()%></b>&nbsp;<%=site.getSite_jang()%></td>		  
                    <td class='title' style="font-size : 8pt;"> ���� </td>
                    <td colspan='3'>&nbsp; 
                      <%if(site.getSite_st().equals("1")) 		out.println("����");
                      	else if(site.getSite_st().equals("2"))  out.println("����");%>
                    </td>
                </tr>
		        <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">����ڹ�ȣ</td>
        		    <td width="15%">&nbsp;<%=site.getEnp_no()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">�׿����ڵ�</td>
        		    <td width="15%">&nbsp;<%=site.getVen_code()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">�繫�ǹ�ȣ</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(site.getTel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">�ѽ���ȣ</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(site.getFax())%></td>				  
		        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">�ּ�</td>
        		    <td colspan='7' style="font-size : 8pt;">&nbsp;<%if(!site.getAddr().equals("")){%>(<%=site.getZip()%>)<%=site.getAddr()%><%}%></td>
		        </tr>
		        <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">����</td>
        		    <td colspan='3' >&nbsp;<%=site.getBus_cdt()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">����</td>
        		    <td colspan='3' >&nbsp;<%=site.getBus_itm()%></td>
		        </tr>
            </table>
        </td>
	</tr> 
	<%}%>   			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='10%' class='title' style="font-size : 8pt;">�����ּ�</td>
                    <td width='65%' align='left'>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
                    <td width='10%' class='title' style="font-size : 8pt;">FMS</td>
                    <td width='15%' align='left' style="font-size : 8pt;">&nbsp;ID&nbsp; :<%=m_bean.getMember_id()%><br>&nbsp;PW:<%=m_bean.getPwd()%></td>			
                </tr>		  
            </table>
        </td>
    </tr>	
    <tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="10%" style="font-size : 8pt;">����</td>
                    <td class=title width="10%" style="font-size : 8pt;">�ٹ�ó</td>			
                    <td class=title width="10%" style="font-size : 8pt;">�μ�</td>
                    <td class=title width="10%" style="font-size : 8pt;">����</td>
                    <td class=title width="10%" style="font-size : 8pt;">����</td>
                    <td class=title width="13%" style="font-size : 8pt;">��ȭ��ȣ</td>
                    <td class=title width="13%" style="font-size : 8pt;">�޴���</td>
                    <td class=title style="font-size : 8pt;">E-MAIL</td>
                </tr>
		        <%if(base.getTax_type().equals("1")){%>
                <tr> 
                    <td align='center'>���ݰ�꼭</td>
                    <td align='center'>����</td>
                    <td align='center'><%=client.getCon_agnt_dept()%></td>
                    <td align='center'><%=client.getCon_agnt_nm()%></td>
                    <td align='center'><%=client.getCon_agnt_title()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%></td>
                    <td align='center'><%=client.getCon_agnt_email()%></td>
                </tr>		  
		        <%}else if(base.getTax_type().equals("2")){%>
                <tr> 
                    <td align='center'>���ݰ�꼭</td>
                    <td align='center'>����</td>
                    <td align='center'><%=site.getAgnt_dept()%></td>
                    <td align='center'><%=site.getAgnt_nm()%></td>
                    <td align='center'><%=site.getAgnt_title()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(site.getAgnt_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(site.getAgnt_m_tel())%></td>
                    <td align='center'><%=site.getAgnt_email()%></td>
                </tr>
        		  <%}%>
        		  <%String mgr_zip = "";
        			String mgr_addr = "";
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("�����̿���")){
        					mgr_zip = mgr.getMgr_zip();
        					mgr_addr = mgr.getMgr_addr();
        				}%>
                <tr> 
                    <td align='center'><%=mgr.getMgr_st()%></td>
                    <td align='center'><%=mgr.getCom_nm()%></td>
                    <td align='center'><%=mgr.getMgr_dept()%></td>
                    <td align='center'><%=mgr.getMgr_nm()%></td>
                    <td align='center'><%=mgr.getMgr_title()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%></td>
                    <td align='center'><%=mgr.getMgr_email()%></td>
                </tr>
		        <%	} %>
            </table>
        </td>
    </tr>
    <tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
        <td align='right'><span class="c"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></span></td>
    </tr>
</table>	
</body>
</html>
