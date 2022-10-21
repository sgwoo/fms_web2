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
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 		= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")){ base.setCar_gu(base.getReg_id()); }
	
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
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
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
	
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	//���°� Ȥ�� ���������϶� �°��� ��������
	Hashtable cng_cont = af_db.getScdFeeCngContA(rent_mng_id, rent_l_cd);
	
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
	<%if(String.valueOf(begin.get("CLS_ST")).equals("���°�") || String.valueOf(cng_cont.get("CLS_ST")).equals("��������") || String.valueOf(cng_cont.get("CLS_ST")).equals("4") || String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>
	<tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>[���°�] ����� : <%=begin.get("RENT_L_CD")%> <%=begin.get("FIRM_NM")%>, �°����� : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%> <%}%>
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("��������")){%>[��������] ����� : <%=begin.get("RENT_L_CD")%> <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, �������� : <%=begin.get("CLS_DT")%><%}%>            	    
					
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>[���°�] �°��� : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, �°����� : <%if(String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("")){%><%=cng_cont.get("CLS_DT")%><%}else{%><%=cng_cont.get("RENT_SUC_DT")%><%}%> <%if(!String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("") && !String.valueOf(cng_cont.get("RENT_SUC_DT")).equals(String.valueOf(cng_cont.get("CLS_DT")))){%>, �������� : <%=cng_cont.get("CLS_DT")%><%}%> <%}%>
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>[��������] ������ : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, �������� : <%=cng_cont.get("CLS_DT")%> <%}%>					
					</font>&nbsp;
					</td>					
                </tr>
            </table>            
        </td>
    </tr>    
    <tr> 
        <td class=h></td>
    </tr>
    <%}%>
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
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}else if(car_gu.equals("3")){%>����Ʈ<%}%></td>
                    <td class=title style="font-size : 8pt;">�뵵����</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("4")){%>����Ʈ<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
                    <td class=title style="font-size : 8pt;">��������</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td style='height:5'>
        	<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %>&nbsp;(������Ʈ �����������:<%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)<%}%>
        </td>
    </tr> 
    <tr>
        <td style='height:20' align="right"><a href="lc_rent_doc_bag.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=rent_st%>" target='_blank'><img src=/acar/images/center/button_gybt.gif align=absmiddle border=0></a></td>
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
                      <%if(client.getClient_st().equals("1")){ 		out.println("����");
                      }else if(client.getClient_st().equals("2")){  out.println("����");
                      }else if(client.getClient_st().equals("3")){ 	out.println("���λ����(�Ϲݰ���)");
                      }else if(client.getClient_st().equals("4")){	out.println("���λ����(���̰���)");
                      }else if(client.getClient_st().equals("5")){ 	out.println("���λ����(�鼼�����)"); }%>
                    </td>
                </tr>
    		    <%if(!client.getClient_st().equals("2")){%>
    		    <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">����ڹ�ȣ<br/></td>
        		    <td colspan="3">&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;"><%if(client.getClient_st().equals("1")){%>���ι�ȣ<%}else{%>�������<%}%></td>
        		    <td colspan="3">&nbsp;<%=client.getSsn1()%>-<%if(client.getClient_st().equals("1")){%><%=client.getSsn2()%><%}else{%><%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%><%}%></td>
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
        		    <td colspan="3">&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%></td>
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
	        		    <td>&nbsp;<%if(client.getPay_st().equals("1")){ 		out.println("�޿��ҵ�");
		        		    }else if(client.getPay_st().equals("2")){    out.println("����ҵ�");
		        		    }else if(client.getPay_st().equals("3")){    out.println("��Ÿ����ҵ�"); }%>
	        		    </td>
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
                      <%if(client.getPrint_st().equals("1")){ 		out.println("���Ǻ�");
                      }else if(client.getPrint_st().equals("2")){   out.println("�ŷ�ó����");
                      }else if(client.getPrint_st().equals("3")){ 	out.println("��������");
                      }else if(client.getPrint_st().equals("4")){	out.println("��������"); }%>
                    </td>
                    <td class='title' style="font-size : 8pt;">��꼭���</td>
                    <td>&nbsp;<%if(!client.getBigo_yn().equals("Y")){%>��ǥ��<%}%></td>
                    <td class='title' style="font-size : 8pt;">�׿����ڵ�</td>
                    <td colspan="3">&nbsp;<%if(!client.getVen_code().equals("")){%>(<%=client.getVen_code()%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%></td>
                </tr>
                <tr>
                    <td class='title' style="font-size : 7pt;">�ŷ���������</td>
                    <td colspan="3">&nbsp;<%  if(client.getItem_mail_yn().equals("N")){ 		out.println("�ź�");
                    	}else{   										out.println("�¶�"); }
                     	%></td>		   
                    <td class='title' style="font-size : 7pt;">���ݰ�꼭����</td>
                    <td colspan="3">&nbsp;<%  if(client.getTax_mail_yn().equals("N")){ 		out.println("�ź�");
                    	}else{   										out.println("�¶�"); }
                     	%></td>		   									
    		    <tr>
                    <td class='title' style="font-size : 8pt;">���ϰźλ���</td>
                    <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>		   
                    <td class='title' style="font-size : 8pt;">��ü���ڼ���</td>
                    <td colspan="3">&nbsp;<%  if(client.getDly_sms().equals("N")){ 		out.println("�ź�");
                    	}else{   										out.println("�¶�"); }%></td>		   					
                </tr>	
                <tr>
                    <td class='title' style="font-size : 8pt;">��å��CMSû������</td>
                    <td colspan="3">&nbsp;<%  if (client.getEtc_cms().equals("N")){ 		out.println("�ź�");
	                    }else if (client.getEtc_cms().equals("Y")){ 	out.println("�¶�");
	    				}else{  										out.println("  "); }
                     	%>
                      &nbsp;&nbsp;* CMS �ŷ����� ����.</td>		   
                    <td class='title' style="font-size : 8pt;">�������·�û������</td>
                    <td colspan="3">&nbsp;<%  if (client.getFine_yn().equals("N")){ 		out.println("�ź�");
	                    }else if (client.getFine_yn().equals("Y")){ 	out.println("�¶�");
	                    }else{  										out.println("  "); }
                     	%>
                    </td>		   					
                </tr>	                		
                 <tr>
                    <td class='title' style="font-size : 8pt;">��ü���� CMSû������</td>
                    <td colspan="7">&nbsp;<%  if (client.getDly_yn().equals("N")){ 		out.println("�ź�");
	                    }else if (client.getDly_yn().equals("Y")){ 	out.println("�¶�");
	                    }else{  										out.println("  "); }
                     	%>
                      &nbsp;&nbsp;* CMS �ŷ����� ����.</td>	   
                  		   					
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
                      <%if(site.getSite_st().equals("1")){ 		out.println("����");
                      	}else if(site.getSite_st().equals("2")){  out.println("����"); }%>
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
                    <td align='left'>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
                </tr>		  
                <%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",ck_acar_id)){%>
                <tr>
                    <td width='10%' class='title' style="font-size : 8pt;">FMS</td>
                    <td align='left'>&nbsp;ID:&nbsp;<%=m_bean.getMember_id()%> &nbsp;PW:&nbsp;<%=m_bean.getPwd()%></td>			
                </tr>
                <%}%>
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
                <tr> 
                    <td align='center'>���ݰ�꼭</td>
                    <td align='center'>�߰������</td>
                    <td align='center'><%=client.getCon_agnt_dept2()%></td>
                    <td align='center'><%=client.getCon_agnt_nm2()%></td>
                    <td align='center'><%=client.getCon_agnt_title2()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(client.getCon_agnt_o_tel2())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(client.getCon_agnt_m_tel2())%></td>
                    <td align='center'><%=client.getCon_agnt_email2()%></td>
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
<tr> 
                    <td align='center'>���ݰ�꼭</td>
                    <td align='center'>�߰������</td>
                    <td align='center'><%=site.getAgnt_dept2()%></td>
                    <td align='center'><%=site.getAgnt_nm2()%></td>
                    <td align='center'><%=site.getAgnt_title2()%></td>
                    <td align='center'><%=site.getAgnt_tel2()%></td>
                    <td align='center'><%=site.getAgnt_m_tel2()%></td>
                    <td align='center'><%=site.getAgnt_email2()%></td>
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
    <%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",ck_acar_id)){%>    	  
    <tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ���������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class=title style="font-size : 8pt;">����</td>
        	        <td width='15%' class=title style="font-size : 8pt;">ȸ��</td>
                    <td width='15%' class=title style="font-size : 8pt;">������</td>
                    <td width='7%' class=title style="font-size : 8pt;">�̸�</td>
                    <td width='8%' class=title style="font-size : 8pt;">����</td>
                    <td width='12%' class=title style="font-size : 8pt;">��ȭ��ȣ</td>
                    <td width='12%' class=title style="font-size : 8pt;">�޴���</td>
                    <td width='12%' class=title style="font-size : 8pt;">FAX</td>
                    <td width='9%' class=title style="font-size : 8pt;">��������</td>					
                </tr>
		        <%if(!String.valueOf(mgr_bus.get("NM")).equals("") && !String.valueOf(mgr_bus.get("NM")).equals("null")){%>
                <tr> 
                    <td align='center'>����</td>
                    <td align='center'><%=mgr_bus.get("COM_NM")%></td>
                    <td align='center'><%=mgr_bus.get("CAR_OFF_NM")%></td>
                    <td align='center'><%=mgr_bus.get("NM")%></td>
                    <td align='center'><%=mgr_bus.get("POS")%> </td>
                    <td align='center'><%=mgr_bus.get("O_TEL")%> </td>
                    <td align='center'><%=mgr_bus.get("TEL")%> </td>
                    <td align='center'><%=mgr_bus.get("FAX")%> </td>
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(mgr_bus.get("COMMI")))%>��</td>					
                </tr>		  
        		  <%}%>
        		  <%if(!String.valueOf(mgr_dlv.get("NM")).equals("") && !String.valueOf(mgr_dlv.get("NM")).equals("null")){%>
                <tr> 
                    <td align='center'>���</td>
                    <td align='center'><%=mgr_dlv.get("COM_NM")%></td>
                    <td align='center'><%=mgr_dlv.get("CAR_OFF_NM")%></td>
                    <td align='center'><%=mgr_dlv.get("NM")%></td>
                    <td align='center'><%=mgr_dlv.get("POS")%> </td>
                    <td align='center'><%=mgr_dlv.get("O_TEL")%> </td>
                    <td align='center'><%=mgr_dlv.get("TEL")%> </td>
                    <td align='center'><%=mgr_dlv.get("FAX")%> </td>
                    <td align='center'>-</td>					
                </tr>
		        <%}%>
            </table>
        </td>
    </tr>
    <%}%>	
    <tr>
        <td style='height:15'></td>
    </tr>  
	<%if(!ins.getCar_mng_id().equals("")){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ�������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="10%" class=title style="font-size : 8pt;">����ȸ��</td>
                    <td width="15%">&nbsp;<b><font color='#990000'><span title='���ԱⰣ : <%=ins.getIns_start_dt()%> 24��~<%=ins.getIns_exp_dt()%> 24��'><%=ins_com_nm%></span></font></b></td>
                    <td class=title width="10%" style="font-size : 8pt;">���ι��</td>
                    <td width=15%> 
                      <%if(ins.getVins_pcp_kd().equals("1")){%>
                      &nbsp;����
                      <%}%>
                      <%if(ins.getVins_pcp_kd().equals("2")){%>
                      &nbsp;����
                      <%}%>
                    </td>
                    <td width=10% class=title style="font-size : 8pt;">�빰���</td>
                    <td> 
                      <%if(ins.getVins_gcp_kd().equals("6")){%>
                      &nbsp;5��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("8")){%>
                      &nbsp;3��� 
                      <%}%>
					  <%if(ins.getVins_gcp_kd().equals("7")){%>
                      &nbsp;2��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("3")){%>
                      &nbsp;1��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("1")){%>
                      &nbsp;3õ���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("2")){%>
                      &nbsp;1õ5�鸸�� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("5")){%>
                      &nbsp;1õ���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("4")){%>
                      &nbsp;5õ���� 
                      <%}%>
                    </td>
                </tr>
                <tr>
                  <td width="10%" class=title style="font-size : 8pt;">�Ǻ�����</td>
                  <td width="15%">&nbsp;
                    <%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%>
                    <%=ins.getCon_f_nm()%>
                    <%}else{%>
                    <b><font color='#990000'><%=ins.getCon_f_nm()%></font></b>
                  <%}%></td>
                  <td class=title style="font-size : 8pt;">���迬��</td>
                  <td>&nbsp;
                    <%if(ins.getAge_scp().equals("1")){%>
                    21���̻�
                    <%}%>
                    <%if(ins.getAge_scp().equals("4")){%>
                    24���̻�
                    <%}%>
                    <%if(ins.getAge_scp().equals("2")){%>
                    26���̻�
                    <%}%>
                    <%if(ins.getAge_scp().equals("3")){%>
                    ������
                    <%}%>
                    <%if(ins.getAge_scp().equals("5")){%>
                    30���̻�
                    <%}%>
                    <%if(ins.getAge_scp().equals("6")){%>
                    35���̻�
                    <%}%>
                    <%if(ins.getAge_scp().equals("7")){%>
                    43���̻�
                    <%}%>
                    <%if(ins.getAge_scp().equals("8")){%>
                    48���̻�
                    <%}%></td>
                  <td class=title style="font-size : 8pt;">�ڱ��ü</td>
                  <td>&nbsp;1�δ���/���:
                    <%if(ins.getVins_bacdt_kd().equals("1")){%>
					3���
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("2")){%>
					1��5õ����
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("3")){%>
					3õ����
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("4")){%>
					1õ5�鸸��
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("5")){%>
					5õ����
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("6")){%>
					1���
					<%}%>
					, 1�δ�λ�:
					<%if(ins.getVins_bacdt_kc2().equals("1")){%>
					3���
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("2")){%>
					1��5õ����
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("3")){%>
					3õ����
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("4")){%>
					1õ5�鸸��
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("5")){%>
					5õ����
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("6")){%>
					1���
					<%}%>
					</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">������å��</td>
                  <td>&nbsp; <%=AddUtil.parseDecimal(base.getCar_ja())%>��</td>
                  <td class=title style="font-size : 8pt;">������������</td>
                  <td>&nbsp;
                    <%if(ins.getVins_canoisr_amt()>0){%>
����
<%}else{%>
-
<%}%></td>
                  <td class=title style="font-size : 8pt;">�ڱ���������</td>
                  <td>&nbsp;
                    <%if(ins.getVins_cacdt_cm_amt()>0){%>
					<b><font color='#990000'>
���� ( ���� <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>����, �ڱ�δ�� <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>����)
                    </font></b>
					<%}else{%>
                    -
                    <%}%></td>
                </tr>	                			
            </table>
        </td>
    </tr>
    <tr>
        <td style='height:15'></td>
    </tr>
	<%}%>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		    <%if(!cr_bean.getCar_no().equals("")){%>
		        <tr>
                	<td width="10%" class='title' style="font-size : 8pt;">������ȣ</td>
        		    <td width="15%">&nbsp;<b><font color='#990000'><%=cr_bean.getCar_no()%></font></b></td>
        		    <td width='10%' class='title' style="font-size : 8pt;">������ȣ</td>
        		    <td width="15%">&nbsp;<%=cr_bean.getCar_doc_no()%></td>
                	<td width="10%" class='title' style="font-size : 8pt;">���ʵ����</td>
        		    <td width="15%">&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                	<td width="10%" class='title' style="font-size : 8pt;">���ɸ�����</td>
        		    <td width="15%">&nbsp;<%=cr_bean.getCar_end_dt()%></td>
		        </tr>			  
		        <%}%>	  
                <tr>
                    <td class='title' style="font-size : 8pt;">�ڵ���ȸ��</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' style="font-size : 8pt;">����</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' style="font-size : 8pt;">����</td>
                    <td colspan="3">&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[������]<%}%><%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title' style="font-size : 8pt;">�ɼ�</td>
                    <td colspan="7">&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                    <td class='title' style="font-size : 8pt;">����</td>
                    <td colspan="7">&nbsp;<%=car.getColo()%>&nbsp;/&nbsp;<%=car.getIn_col()%>&nbsp;/&nbsp;<%=car.getGarnish_col()%></td>
                </tr>
                <tr>
                    <td  width="10%" class='title' style="font-size : 8pt;"> ����</td>
                    <td width="15%">&nbsp;<%=car.getSun_per()%>%</td>
                    <td  width="10%" class='title' style="font-size : 8pt;">�Һз� </td>
                    <td width="15%">&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%>&nbsp;<%=cm_bean.getSh_code()%></td>
                    <td  width="10%" class='title' style="font-size : 8pt;">��ⷮ</td>
                    <td width="15%">&nbsp;<%=cm_bean.getDpm()%>cc</td>
                    <td  width="10%" class='title' style="font-size : 8pt;">�������</td>			
                    <td width="15%">&nbsp;<%String car_ext = car.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
                </tr>
                <%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",ck_acar_id)){%>    	  
                <tr>
                    <td class='title' style="font-size : 8pt;">�⺻����</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>��</td>
                    <td class='title' style="font-size : 8pt;">�ɼǰ�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>��</td>
                    <td class='title' style="font-size : 8pt;">����</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>��</td>
                    <td class='title' style="font-size : 8pt;">����DC</td>			
                    <td>&nbsp;<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>��</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",ck_acar_id)){%>    	  
    <tr>
        <td style='height:15'></td>
    </tr>  	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="4%" class=title rowspan="2">����</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">�������</td>
                    <td style="font-size : 8pt;" width="4%" class=title rowspan="2">�̿�<br>�Ⱓ</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">�����</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">���뿩��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">������</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">������</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���ô뿩��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���Կɼ�</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="9%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="4%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="9%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="4%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="9%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="4%" class=title>%</td>			
                </tr>
		        <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getRent_dt()%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getRent_start_dt()%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getRent_end_dt()%></td>
                    <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
		        <%}}%>
            </table>
	    </td>
	</tr>
	<%if(!cms.getCms_bank().equals("")){%>
	<tr>
        <td style='height:15'></td>
    </tr>  	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ���ü</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td  width="10%" class='title' style="font-size : 8pt;">�ŷ�����</td>
                    <td width="15%">&nbsp;<%=cms.getCms_bank()%></td>
                    <td  width="10%" class='title' style="font-size : 8pt;">��ü�� </td>
                    <td width="15%">&nbsp;<%=cms.getCms_day()%>��</td>
                    <td  width="10%" class='title' style="font-size : 8pt;">����Ⱓ</td>
                    <td width="40%">&nbsp;<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>
					&nbsp;&nbsp;
					<!--
					<b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
        			&nbsp;&nbsp;<a href="acms_list.jsp?acode=<%=rent_l_cd%>" target="_blank"><img src=/acar/images/center/button_in_acms.gif border=0 align=absmiddle></a>
        			-->
        			</td>
                </tr>
            </table>
        </td>
    </tr>
	<%}%>	
	<%-- <%if(gins.getGi_st().equals("1") || car.getGi_st().equals("1")){%>
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
                    <td width="10%" class='title' style="font-size : 8pt;">���Աݾ�</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(gins.getGi_amt())%>��</td>
                    <td width="10%" class=title  style="font-size : 8pt;">���������</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(gins.getGi_fee())%>��</td>
                    <td width="10%" class=title style="font-size : 8pt;">��������</td>
                    <td width="15%">&nbsp;<%=gins.getGi_jijum()%></td>
                    <!-- �������� ���԰��� �߰�(2018.03.22) -->
                    <td width="10%" class=title style="font-size : 8pt;">���԰���</td>
                    <td width="15%">&nbsp;<%=gins.getGi_month()%><%if(!gins.getGi_month().equals("")){%>����<%}%></td>
                </tr>
            </table>
	    </td>
    </tr>    
	<%}%> --%>
	
	<!-- ��������� �������� �̷� ��� ǥ��(20190826) -->
	<%if(!base.getCar_st().equals("4")){%>
    <%	
		  //���ຸ������
		  	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
		  	if(gin_size==0) gin_size = 1;
		  	String user_id = ck_acar_id;
			for(int f=1; f<=gin_size ; f++){
				ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));
		%>       
    <tr>
        <td class=h></td>
    </tr> 
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f >1){%><%=f%>�� ���� <%}%>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="5">&nbsp;<%if(ext_gin.getGi_st().equals("1")){%>����<%}else if(ext_gin.getGi_st().equals("0")){%>����<%}%></td>
                </tr>
                <tr id=tr_gi1 style="display:<%if(ext_gin.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>��</td>
                    <td width="10%" class=title >���������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>��</td>
                </tr>
                <tr id=tr_gi2 style="display:<%if(ext_gin.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>���ǹ�ȣ</td>
                    <td width="20%">&nbsp;��<%=ext_gin.getGi_no()%>ȣ</td>
                    <td width="10%" class='title'>����Ⱓ</td>
                    <td width="20%" >&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_start_dt())%>~<%=AddUtil.ChangeDate2(ext_gin.getGi_end_dt())%></td>
                    <td class=title >���谡������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
   		<%}%>
    <%}%>
	
    <%}%>
	<%if(!cls.getRent_l_cd().equals("")){%>
	<tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="10%" class='title' style="font-size : 8pt;">��������</td>
                    <td width="15%">&nbsp;<%=cls.getCls_st()%></td>
                    <td width="10%" class=title  style="font-size : 8pt;">��������</td>
                    <td width="15%">&nbsp;<%=cls.getCls_dt()%></td>
                    <td width="10%" class=title style="font-size : 8pt;">��������</td>
                    <td width="40%">&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%></td>
                </tr>
            </table>
	    </td>
    </tr>    
	<%}%>	
    <tr>
        <td align='center'><span class="c"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></span></td>
    </tr>
</table>	
</body>
</html>
