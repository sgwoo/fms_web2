<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*" %>
<%@ page import="acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<rows>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	//String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String period_gubun = request.getParameter("period_gubun")==null?"":request.getParameter("period_gubun");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"2":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String branch = request.getParameter("branch")==null?"":request.getParameter("branch");		//�������� �˻��߰�
	String bus_user_id = request.getParameter("bus_user_id")==null?"":request.getParameter("bus_user_id");		//��ȭ�ۼ��� �˻��߰�
	String cmd = "";
	
	if(!gubun4.equals("3")){
		s_dt = "";
		e_dt = "";
	}

	if(user_id.equals("")) 	user_id = ck_acar_id;
	
	String est_st = "";
	String answer = "";
	String b_note = "";
	String client = "";
	String name = "";
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//���뺯��
	EstiDatabase e_db = EstiDatabase.getInstance();	

	//EstiSpeBean [] e_r = e_db.getEstiSpeList(gubun1, period_gubun, gubun3, gubun4, s_dt, e_dt, s_kd, t_wd, esti_m, esti_m_dt, esti_m_s_dt, esti_m_e_dt, branch );
	EstiSpeBean [] e_r = e_db.getEstiSpeList2(gubun1, period_gubun, gubun3, gubun4, s_dt, e_dt, s_kd, t_wd, esti_m, esti_m_dt, esti_m_s_dt, esti_m_e_dt, branch, bus_user_id);
	int size = e_r.length +1;
	System.out.println(e_r.length);
   
	if (e_r.length > 0 ) {
			 
		for (int i=0; i < e_r.length; i++) {
			
			bean = e_r[i];
			
			if(bean.getEst_st().equals("PM1")||bean.getEst_st().equals("PM2")||bean.getEst_st().equals("PM3")) continue;
			
			String rent_yn = bean.getRent_yn().replaceAll("[\r\n]", " ");
			String etc = bean.getEtc().replaceAll("[\r\n]", " ");
			
			size = size -1;
			
			//����1
			if(bean.getEst_st().equals("B")||bean.getEst_st().equals("P")){
	 	 		est_st = "M";
	 	 	}else if(bean.getEst_st().equals("M")||bean.getEst_st().equals("N")){
	 	 		est_st = "��";
	 	 	}else if(bean.getEst_st().equals("MSB")||bean.getEst_st().equals("MSP")||bean.getEst_st().equals("MS1")||bean.getEst_st().equals("MS2")||bean.getEst_st().equals("MS3") ){
	 	 		est_st = "M��";
	 	 	}else if(bean.getEst_st().equals("MJB")||bean.getEst_st().equals("MJP") || bean.getEst_st().equals("MJ1")||bean.getEst_st().equals("MJ2")||bean.getEst_st().equals("MJ3")){
	 	 		est_st = "M��";
	 	 	}else if(bean.getEst_st().equals("MMB")||bean.getEst_st().equals("MMP")){
	 	 		est_st = "M��";
	 	 	}else if(bean.getEst_st().equals("PS1")||bean.getEst_st().equals("PS2")||bean.getEst_st().equals("PS3")){
	 	 		est_st = "P��";
	 	 	}else if(bean.getEst_st().equals("PJ1")||bean.getEst_st().equals("PJ2")||bean.getEst_st().equals("PJ3")){
	 	 		est_st = "P��";
	 	 	}else if(bean.getEst_st().equals("PM1")||bean.getEst_st().equals("PM2")||bean.getEst_st().equals("PM3")){
	 	 		est_st = "P��";
	 	 	}else if(bean.getEst_st().equals("PE9")) {
	 	 		est_st = "P��";
	 	 	}else if(bean.getEst_st().equals("PH9")) {
	 	 		est_st = "P��";
	 	 	}else if(bean.getEst_st().equals("ME9")) {
	 	 		est_st = "M��";
	 	 	}else if(bean.getEst_st().equals("MH9")) {
	 	 		est_st = "M��";
	 	 	}else if(bean.getEst_st().equals("PC4")) {
	 	 		est_st = "P��";
	 	 	}else if(bean.getEst_st().equals("MO4")) {
	 	 		est_st = "M��";
	 	 	}else if(bean.getEst_st().equals("ARS")) {
	 	 		est_st = "A��";
	 	 	}else{
	 	 		est_st = "";
	 	 	}
			
			//��ȭ2
	 	 	if((bean.getM_reg_dt().equals("") && bean.getB_reg_dt().equals("") && bean.getT_reg_dt().equals(""))){
		 	 	answer = "��ȭ^javascript:EstiMemo(&#39;"+bean.getEst_id()+"&#39;, &#39;"+user_id+"&#39;, &#39;1&#39;, &#39;&#39;, &#39;&#39;);^_self";
	 	 	}else{
	 	 		//��ȭ�ų� �������̰ų� ����̰ų�
	 	 		if( !bean.getT_reg_dt().equals("") ){
	 	 			answer = AddUtil.ChangeDate6(bean.getT_reg_dt()) +" "+c_db.getNameById(bean.getT_user_id(), "USER_DE")+" "+c_db.getNameById(bean.getT_user_id(), "USER")+"^javascript:EstiMemo(&#39;"+bean.getEst_id()+"&#39;, &#39;"+user_id+"&#39;, &#39;2&#39;, &#39;"+bean.getB_reg_dt()+"&#39;, &#39;"+bean.getT_reg_dt()+"&#39;);^_self";
	 	 		}else{
	 	 			 if( !bean.getB_note().equals("") ){
	 	 				answer = AddUtil.ChangeDate6(bean.getB_reg_dt()) +" "+bean.getB_note()+"^javascript:EstiMemo(&#39;"+bean.getEst_id()+"&#39;, &#39;"+user_id+"&#39;, &#39;2&#39;, &#39;"+bean.getB_reg_dt()+"&#39;, &#39;"+bean.getT_reg_dt()+"&#39;);^_self";//
	 	 			 }
	 	 		}
	 	 	}
			
	 	 	 //�����3
	 	 	if ( !bean.getB_note().equals("") ){
	 	 		b_note =  bean.getB_note();
	 	 	}else{
	 	 		b_note =  rent_yn;	
	 	 	}
	 	 	 
	 		 //������5
	 	 	if(bean.getEst_st().equals("1")||bean.getEst_st().equals("B")||bean.getEst_st().equals("M")||bean.getEst_st().equals("PS1")||bean.getEst_st().equals("PJ1")||bean.getEst_st().equals("PM1")||bean.getEst_st().equals("MSB")||bean.getEst_st().equals("MJB")||bean.getEst_st().equals("MMB") ||bean.getEst_st().equals("MS1")||bean.getEst_st().equals("MJ1") ){
	 	 		client =  "����";
	 	 	}else if(bean.getEst_st().equals("2")||bean.getEst_st().equals("P")||bean.getEst_st().equals("N")||bean.getEst_st().equals("PS2")||bean.getEst_st().equals("PJ2")||bean.getEst_st().equals("PM2")||bean.getEst_st().equals("MSP")||bean.getEst_st().equals("MJP")||bean.getEst_st().equals("MMP") ||bean.getEst_st().equals("MS2")||bean.getEst_st().equals("MJ2")){
	 	 		client =  "���λ����";
	 	 	}else if(bean.getEst_st().equals("PE9")||bean.getEst_st().equals("PH9")||bean.getEst_st().equals("ME9")||bean.getEst_st().equals("MH9")){
	 	 		client =  "��������";
	 	 	}else if(bean.getEst_st().equals("PC4")||bean.getEst_st().equals("MO4")){
	 	 		client =  "������";
	 	 	}else if(bean.getEst_st().equals("ARS")){
	 	 		client =  "ARS���";
	 	 	}else{
	 	 		client =  "�� ��";
	 	 	}
	 	 	 
	 	 	//����/���θ�6
	 		if(bean.getClient_yn().equals("Y")){
	 			name = "<b>������-"+bean.getEst_nm() + "</b>";
			}else{
				name = bean.getEst_nm();
			}
	 	 	
	 		//��������8
	 		if(bean.getEst_st().equals("ARS")){
	 			
	 			if (bean.getEst_area().equals("����")) {
					if (bean.getCounty().equals("����")) {
						branch = "����";
					} else if (bean.getCounty().equals("��ȭ��")) {
						branch = "��ȭ��";
					} else if (bean.getCounty().equals("����")) {
						branch = "����";
					} else {
						branch = "����";
					}				
				} else if (bean.getEst_area().equals("�λ�")) {
					branch = "�λ�";
				} else if (bean.getEst_area().equals("����")) {
					branch = "����";
				} else if (bean.getEst_area().equals("��õ")) {
					branch = "��õ";
				} else if (bean.getEst_area().equals("�뱸")) {
					branch = "�뱸";
				} else if (bean.getEst_area().equals("����")) {
					branch = "����";
				} else if (bean.getEst_area().equals("����")) {
					branch = "����";
				}
	 	 		
	 	 	} else {
	 	 		
				if(bean.getEst_area().equals("����")){
					if(bean.getCounty().equals("������")||bean.getCounty().equals("���ʱ�")||bean.getCounty().equals("������")){
						branch = "����";
					}else if(bean.getCounty().equals("���α�")||bean.getCounty().equals("���빮��")||bean.getCounty().equals("�߱�")||bean.getCounty().equals("��걸")||bean.getCounty().equals("�߶���")||bean.getCounty().equals("�����")||bean.getCounty().equals("���ϱ�")||bean.getCounty().equals("���빮��")||bean.getCounty().equals("����")||bean.getCounty().equals("������")||bean.getCounty().equals("���ϱ�")) {
						branch = "��ȭ��";
					}else if(bean.getCounty().equals("���ı�")||bean.getCounty().equals("������")||bean.getCounty().equals("������")) {
						branch = "����";
					}else{
						branch = "����";
					}
				}else if(bean.getEst_area().equals("��õ")){
					branch = "��õ";
				}else if(bean.getEst_area().equals("���")){
					if(bean.getCounty().equals("��õ��")){
						branch = "����";
					}else if(bean.getCounty().equals("������")||bean.getCounty().equals("��õ��")||bean.getCounty().equals("�����")){
						branch = "��õ";
					}else if(bean.getCounty().equals("������")||bean.getCounty().equals("������")||bean.getCounty().equals("�Ȼ��")||bean.getCounty().equals("�ȼ���")||bean.getCounty().equals("���ֱ�")||bean.getCounty().equals("�����")||bean.getCounty().equals("���ν�")||bean.getCounty().equals("�ǿս�")||bean.getCounty().equals("��õ��")||bean.getCounty().equals("���ý�")||bean.getCounty().equals("ȭ����")){
						branch = "����";
					}else if(bean.getCounty().equals("����")||bean.getCounty().equals("������")||bean.getCounty().equals("�ϳ���")||bean.getCounty().equals("���ֽ�")||bean.getCounty().equals("�����ֽ�")||bean.getCounty().equals("����")||bean.getCounty().equals("������")){
						branch = "����";
					}else if(bean.getCounty().equals("����õ��")||bean.getCounty().equals("���ֽ�")||bean.getCounty().equals("��õ��")||bean.getCounty().equals("�����ν�")||bean.getCounty().equals("��õ��")){
						branch = "��ȭ��";
					}else{
						branch = "����";
					}
				}else if(bean.getEst_area().equals("����")){
					if(bean.getCounty().equals("��õ��")||bean.getCounty().equals("�籸��")||bean.getCounty().equals("ö����")||bean.getCounty().equals("ȭõ��")||bean.getCounty().equals("ȫõ��")||bean.getCounty().equals("������")||bean.getCounty().equals("����")||bean.getCounty().equals("���ʽ�")||bean.getCounty().equals("��籺")){
						branch = "����";
					}else{
						branch = "����";
					}
				}else if(bean.getEst_area().equals("�泲")||bean.getEst_area().equals("�λ�")||bean.getEst_area().equals("���")){
					branch = "�λ�";
				}else if(bean.getEst_area().equals("����")||bean.getEst_area().equals("����")||bean.getEst_area().equals("����")||bean.getEst_area().equals("����")){
					branch = "����";
				}else if(bean.getEst_area().equals("�뱸")||bean.getEst_area().equals("���")){
					branch = "�뱸";
				}else if(bean.getEst_area().equals("�泲")||bean.getEst_area().equals("���")||bean.getEst_area().equals("����")||bean.getEst_area().equals("����")){
					branch = "����";
				}
	 	 	}
		//	out.println("id:" +user_id);
		%>
			
		<row  id='<%=i+1%>'>
			<cell><![CDATA[<input type="checkbox" name="content_check" value="<%=bean.getEst_id()%>">]]></cell><!--üũ�ڽ�-->
			<cell><![CDATA[<%=size%>]]></cell><!--����0-->
 	 		<cell><![CDATA[<%=est_st%>]]></cell><!--����1-->
	 	 	<cell><![CDATA[<%=answer%>]]></cell><!--��ȭ2-->
 	 		<cell><![CDATA[<%=b_note%>]]></cell><!--�����3-->
	 	 	<cell><![CDATA[<%=AddUtil.ChangeDate3(bean.getReg_dt())%>]]></cell><!--��û����4-->
	 		<cell><![CDATA[<%=client%>]]></cell><!--������5-->
			<cell><![CDATA[<%=name%>]]></cell><!--����/���θ�6-->			
	 	 	<cell>
	 	 		<![CDATA[
	 	 			<%if (!bean.getEst_st().equals("ARS")) {%>
		 	 			<%=bean.getEst_area()%>
	 	 			<%}%>
	 	 		]]>
	 	 	</cell><!--����7-->
			<cell>
				<![CDATA[
					<%if (bean.getEst_st().equals("MMB") || bean.getEst_st().equals("MMP")) { // ����Ʈ(�����)%>
						<%if(bean.getEst_area().equals("������")){ // ����Ʈ ���̴��� ��������ġ�� �������� ��� �� �ּҿ� ���� �������� ���� %>
							<%=branch%>
		 	 			<%} else { // ������ �� ������ ���� ����ġ�� ���� ���� �÷� �� ���� %>
							<%=bean.getEst_area()%>
		 	 			<%}%>
	 	 			<%} else {%>
						<%=branch%>
	 	 			<%}%>
				]]>
			</cell><!--��������8-->	
			<cell><![CDATA[<%=bean.getEst_agnt()%>]]></cell><!--�����9-->
	 	 	<%-- <cell><![CDATA[<%=AddUtil.phoneFormatAsterisk(bean.getEst_tel())%>]]></cell> --%><!--��ȭ��ȣ10-->
	 	 	<cell><![CDATA[<%=AddUtil.phoneFormat(bean.getEst_tel())%>]]></cell><!--��ȭ��ȣ10-->
	 		<cell>
	 			<![CDATA[
	 				<%if (bean.getEst_st().equals("PE9") || bean.getEst_st().equals("PH9") || bean.getEst_st().equals("ME9") || bean.getEst_st().equals("MH9")) {%>
 	 					<font style="color:red;">��������</font> - <%=bean.getCar_nm()%>
 	 				<%} else if (bean.getEst_st().equals("PC4") || bean.getEst_st().equals("MO4")) {%>
 	 					<font style="color:blue;">�������û</font>
 	 				<%} else if (bean.getEst_st().equals("ARS")) {%>
 	 					<font style="color:green;">ARS����û</font>
 	 				<%} else {%>
 	 					<%=bean.getCar_nm()%>
 	 				<%}%>
	 			]]>
	 		</cell><!--�������14-->
	 	</row>
	<%}
	}%>

</rows>
