<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String rent_mng_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");

	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
		
	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
		
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();
		
	//Ź�۵� ����ó �߰� - 20200611
	Vector ctel_list = cs_db.getConsignmentTelList(rent_l_cd);
	
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
		        <% } %>
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
   
	<tr>
        <td style='height:15'></td>
    </tr>  	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ó</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
               <tr>
          		    <td class=title width="20%" style="font-size : 8pt;">�����</td>
          		    <td class=title width="15%" style="font-size : 8pt;">����</td>
                    <td class=title width="25%" style="font-size : 8pt;">�繫��</td>			
                    <td class=title width="25%" style="font-size : 8pt;">�޴���</td>
                    <td class=title width="15%" style="font-size : 8pt;">Ź�ۿ�</td>
               </tr>     
              <%
        		  	for(int i = 0 ; i <ctel_list.size()  ; i++){
        		  		
        		  		Hashtable ht1 = (Hashtable)ctel_list.elementAt(i);        			
        	  %>
            
                <tr> 
                    <td align='center'><%=ht1.get("MAN")%></td>
                    <td align='center'><%=ht1.get("TITLE")%></td>
                    <td align='center'><%=ht1.get("TEL")%></td>
                    <td align='center'><%=ht1.get("M_TEL")%></td>
                    <td align='center'><%=ht1.get("YM")%></td>               
                  
                </tr>
               <% } %> 
            </table>
        </td>
    </tr>
	
    <tr>
        <td align='center'><span class="c"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></span></td>
    </tr>
</table>	
</body>
</html>
