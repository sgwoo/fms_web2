<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.* "%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<rows>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String opt1 		= request.getParameter("opt1")		==null?"":request.getParameter("opt1");
	String opt2 		= request.getParameter("opt2")		==null?"":request.getParameter("opt2");
	String opt3 		= request.getParameter("opt3")		==null?"":request.getParameter("opt3");
	String opt4 		= request.getParameter("opt4")		==null?"":request.getParameter("opt4");
	String opt5 		= request.getParameter("opt5")		==null?"":request.getParameter("opt5");
	String opt6 		= request.getParameter("opt6")		==null?"":request.getParameter("opt6");
	String opt7 		= request.getParameter("opt7")		==null?"":request.getParameter("opt7");
	String e_opt1 		= request.getParameter("e_opt1")	==null?"":request.getParameter("e_opt1");
	String e_opt2 		= request.getParameter("e_opt2")	==null?"":request.getParameter("e_opt2");
	String e_opt3 		= request.getParameter("e_opt3")	==null?"":request.getParameter("e_opt3");
	String e_opt4 		= request.getParameter("e_opt4")	==null?"":request.getParameter("e_opt4");
	String e_opt5 		= request.getParameter("e_opt5")	==null?"":request.getParameter("e_opt5");
	String e_opt6 		= request.getParameter("e_opt6")	==null?"":request.getParameter("e_opt6");
	String e_opt7 		= request.getParameter("e_opt7")	==null?"":request.getParameter("e_opt7");
	String ready_car 	= request.getParameter("ready_car")	==null?"":request.getParameter("ready_car");
	String user_nm = "";
	String eco_yn 		= request.getParameter("eco_yn")	==null?"":request.getParameter("eco_yn");
	String car_nm2 		= request.getParameter("car_nm2")		==null?"":request.getParameter("car_nm2");
	String car_nm3 		= request.getParameter("car_nm3")		==null?"":request.getParameter("car_nm3");
	
	String first 	= request.getParameter("first")==null?"":request.getParameter("first");
	
	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	Vector vt = new Vector();
	Vector vt2 = new Vector();
	Vector vt3 = new Vector();
	Vector vt4 = new Vector();	
	
	
	if(!first.equals("Y")){
			
		if(ready_car.equals("Y") ){
			
			user_nm = session_user_nm;
			if(ck_acar_id.equals("000314"))	user_nm = "���μ�";		//�̽¿�(������Ʈ)�� ���μ� ����� ����� ���̰�(20181205)
			
			vt  = cop_db.getDirectCarOffPreList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, opt1, opt2, opt3, opt4, opt5, opt6, opt7,				
			 								   	e_opt1, e_opt2, e_opt3, e_opt4, e_opt5, e_opt6, e_opt7, user_nm, "1", eco_yn, acar_de, car_nm2, car_nm3);	//23
		    vt2 = cop_db.getDirectCarOffPreList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, opt1, opt2, opt3, opt4, opt5, opt6, opt7,
			 								    e_opt1, e_opt2, e_opt3, e_opt4, e_opt5, e_opt6, e_opt7, user_nm, "2", eco_yn, acar_de, car_nm2, car_nm3);	//23
			vt3 = cop_db.getDirectCarOffPreList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, opt1, opt2, opt3, opt4, opt5, opt6, opt7,
			 		 						    e_opt1, e_opt2, e_opt3, e_opt4, e_opt5, e_opt6, e_opt7, user_nm, "3", eco_yn, acar_de, car_nm2, car_nm3);	//23
			if(!acar_de.equals("1000")){	//������Ʈ�� 4�� ǥ��x
				vt4 = cop_db.getDirectCarOffPreList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, opt1, opt2, opt3, opt4, opt5, opt6, opt7,
			 				 				    e_opt1, e_opt2, e_opt3, e_opt4, e_opt5, e_opt6, e_opt7, user_nm, "4", eco_yn, acar_de, car_nm2, car_nm3);	//23
			}								   
		}else{
			user_nm = acar_de.equals("1000")?session_user_nm:"";		//������Ʈ�̸� ���ο��� + �̿���Ǹ� ���(20181127)
			if(ck_acar_id.equals("000314"))	user_nm = "���μ�";			//�̽¿�(������Ʈ)�� ���μ� ����� ����� ���̰�(20181205)
			
			vt = cop_db.getCarOffPreList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, opt1, opt2, opt3, opt4, opt5, opt6, opt7,
										 e_opt1, e_opt2, e_opt3, e_opt4, e_opt5, e_opt6, e_opt7, user_nm, eco_yn, acar_de, car_nm2, car_nm3);	//22
		}
	}
	
	int vt_size = vt.size();
	int row_cnt = 0;
	String com_con_no = ""; 
	String bus_nm2 = "";
	String bus_nm3 = "";
	
	if(vt_size > 0){
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			com_con_no = String.valueOf(ht.get("COM_CON_NO"))+"^javascript:view_cont(&#39;"+ht.get("SEQ")+"&#39;);^_self";
			
			//������Ʈ�� ������Ʈ ���� ���̱⸸ ����
			if(acar_de.equals("1000") && !String.valueOf(ht.get("AGENT_VIEW_YN")).equals("Y") ){
				continue;
			}
			
			row_cnt ++;
			
			String engine = "";
			if (ht.get("ECO_YN").equals("0")) {
				engine = "���ָ�����";
			} else if (ht.get("ECO_YN").equals("1")) {
				engine = "��������";	
			} else if (ht.get("ECO_YN").equals("2")) {
				engine = "LPG����";	
			} else if (ht.get("ECO_YN").equals("3")) {
				engine = "���̺긮��";	
			} else if (ht.get("ECO_YN").equals("4")) {
				engine = "�÷����� ���̺긮��";	
			} else if (ht.get("ECO_YN").equals("5")) {
				engine = "������";	
			} else if (ht.get("ECO_YN").equals("6")) {
				engine = "������";	
			}
			
			bus_nm2 = "";
			bus_nm3 = "";
			
			//�����ڰ� ������ ������ ������ ���� �����´�.
			if (!String.valueOf(ht.get("BUS_NM")).equals("")) {
				//�����ڸ���Ʈ
				Vector res_vt = cop_db.getCarOffPreSeqResUseList(String.valueOf(ht.get("SEQ")));
				int res_vt_size = res_vt.size();
				if(res_vt_size>1){
					for(int j = 0 ; j < res_vt_size ; j++){
						Hashtable res_ht = (Hashtable)res_vt.elementAt(j);
						if(j==1){
							bus_nm2 = String.valueOf(res_ht.get("BUS_NM"));
						}
						if(j==2){
							bus_nm3 = String.valueOf(res_ht.get("BUS_NM"));
						}
					}	
				}				
			}
			
			
%>	
		<row  id='<%=row_cnt%>' style="<%if(String.valueOf(ht.get("PRE_OUT_YN")).equals("Y")){%>background-color:#FFD4DF;<%}%>">
			<cell><![CDATA[<%=row_cnt%>]]></cell><!--����0-->
 	 		<cell><![CDATA[<%=ht.get("CAR_OFF_NM")%>]]></cell><!--�������1-->
 	 		<cell><![CDATA[<%if(String.valueOf(ht.get("BUS_SELF_YN")).equals("Y")){%>��ü����<%if(!String.valueOf(ht.get("Q_REG_DT")).equals("")){%>Q<%}%><%}%>]]></cell><!--��ü��������-->
	 	 	<cell><![CDATA[<%=com_con_no%>]]></cell><!--�����ȣ2-->
 	 		<%-- <cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>]]></cell> --%><!--����Ͻ�3-->
 	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%>]]></cell><!--��û�Ͻ�3-->
 	 		<cell><![CDATA[<%=engine%>]]></cell><!--��������4-->
	 	 	<cell><![CDATA[&nbsp;<%=ht.get("CAR_NM")%> ]]></cell><!--����5-->
	 		<cell><![CDATA[&nbsp;<%=ht.get("OPT")%> ]]></cell><!--���6-->
			<cell><![CDATA[<%=ht.get("COLO")%> ]]></cell><!--�������7-->			
	 	 	<cell><![CDATA[<%=ht.get("IN_COL")%> ]]></cell><!--�������8-->
	 	 	<cell><![CDATA[<%=ht.get("GARNISH_COL")%> ]]></cell><!--���Ͻ�����9-->
<%-- 	 	 	<cell><![CDATA[<%=ht.get("BLUE_COL")%>]]></cell><!--����÷��ѿ���10--> --%>
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%>]]></cell><!--�Һ��ڰ�11-->	
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_EST_DT")))%><%if(!acar_de.equals("1000")){%> <%=ht.get("AGENT_VIEW_YN")%><%}%>]]></cell><!--�������12-->
	 		<cell><![CDATA[<%=ht.get("BUS_NM")%>]]></cell><!--1����������13-->
	 		<cell><![CDATA[<%=ht.get("STATUS")%>]]></cell><!--���౸��14-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RES_REG_DT")))%>]]></cell><!--������15-->
	 		<cell><![CDATA[<%if(ht.get("RES_END_DT") != null ){%> <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RES_END_DT")))%> <%}%>]]></cell><!--�����ϸ�����16-->
	 		<cell><![CDATA[<%if( !acar_de.equals("1000") || ( acar_de.equals("1000") && String.valueOf(ht.get("BUS_NM")).equals(user_nm) ) ){ %><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 12)%><%} else{%>***<%}%><%if(String.valueOf(ht.get("CUST_Q")).equals("Q")){%>Q<%}%>]]></cell><!--����ȣ16-->
	 		<cell><![CDATA[<%if( !acar_de.equals("1000") || ( acar_de.equals("1000") && String.valueOf(ht.get("BUS_NM")).equals(user_nm) ) ){ %><%=AddUtil.subData(String.valueOf(ht.get("ADDR")), 7)%><%} else{%>***<%}%>]]></cell><!--���ּ�17-->
	 		<cell><![CDATA[<%if( !acar_de.equals("1000") || ( acar_de.equals("1000") && String.valueOf(ht.get("BUS_NM")).equals(user_nm) ) ){ %><%=ht.get("CUST_TEL")%><%} else{%>***<%}%>]]></cell><!--������ó18-->
	 		<cell><![CDATA[<%=ht.get("MEMO")%>]]></cell><!--�޸�19-->
	 		<cell><![CDATA[<%=ht.get("RENT_L_CD")%>]]></cell><!--����ȣ20-->
	 		<cell><![CDATA[<%=bus_nm2%><%//=ht.get("BUS_NM2")%>]]></cell><!--2���� ������-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%>]]></cell><!--�����21-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%>]]></cell><!--�������������22-->
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht.get("CON_AMT")))%>]]></cell><!--����23-->
	 	 	<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CON_PAY_DT")))%>]]></cell><!--����������24-->
	 	</row>
<%		}	
	}	%>
	
 	
<%	if(vt2.size() > 0){%>
<%		for(int i = 0 ; i < vt2.size() ; i++){
			Hashtable ht2 = (Hashtable)vt2.elementAt(i);
			com_con_no = String.valueOf(ht2.get("COM_CON_NO"))+"^javascript:view_cont(&#39;"+ht2.get("SEQ")+"&#39;);^_self";
			
			//������Ʈ�� ������Ʈ ���� ���̱⸸ ����
			if(acar_de.equals("1000") && !String.valueOf(ht2.get("AGENT_VIEW_YN")).equals("Y") ){
				continue;
			}
			
			row_cnt ++;
			
			String engine2 = "";
			if (ht2.get("ECO_YN").equals("0")) {
				engine2 = "���ָ�����";
			} else if (ht2.get("ECO_YN").equals("1")) {
				engine2 = "��������";	
			} else if (ht2.get("ECO_YN").equals("2")) {
				engine2 = "LPG����";	
			} else if (ht2.get("ECO_YN").equals("3")) {
				engine2 = "���̺긮��";	
			} else if (ht2.get("ECO_YN").equals("4")) {
				engine2 = "�÷����� ���̺긮��";	
			} else if (ht2.get("ECO_YN").equals("5")) {
				engine2 = "������";	
			} else if (ht2.get("ECO_YN").equals("6")) {
				engine2 = "������";	
			}
			
			bus_nm2 = "";
			bus_nm3 = "";
						
			//�����ڰ� ������ ������ ������ ���� �����´�.
			if (!String.valueOf(ht2.get("BUS_NM")).equals("")) {
				//�����ڸ���Ʈ
				Vector res_vt = cop_db.getCarOffPreSeqResUseList(String.valueOf(ht2.get("SEQ")));
				int res_vt_size = res_vt.size();
				if(res_vt_size>1){
					for(int j = 0 ; j < res_vt_size ; j++){
						Hashtable res_ht = (Hashtable)res_vt.elementAt(j);
						if(j==1){
							bus_nm2 = String.valueOf(res_ht.get("BUS_NM"));
						}
						if(j==2){
							bus_nm3 = String.valueOf(res_ht.get("BUS_NM"));
						}
					}	
				}				
			}
			
			
%>
		
		<row  id='<%=row_cnt%>' style="<%if(String.valueOf(ht2.get("PRE_OUT_YN")).equals("Y")){%>background-color:#FFD4DF;<%}%>
									   <%if(i==0){%>border-top:3px solid #B4B4FF;<%}%>">
			<cell><![CDATA[<%=row_cnt%>]]></cell><!--����0-->
 	 		<cell><![CDATA[<%=ht2.get("CAR_OFF_NM")%>]]></cell><!--�������1-->
 	 		<cell><![CDATA[<%if(String.valueOf(ht2.get("BUS_SELF_YN")).equals("Y")){%>��ü����<%if(!String.valueOf(ht2.get("Q_REG_DT")).equals("")){%>Q<%}%><%}%>]]></cell><!--��ü��������-->
	 	 	<cell><![CDATA[<%=com_con_no%>]]></cell><!--�����ȣ2-->
 	 		<%-- <cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>]]></cell> --%><!--����Ͻ�3-->
 	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht2.get("REQ_DT")))%>]]></cell><!--��û�Ͻ�3-->
 	 		<cell><![CDATA[<%=engine2%>]]></cell><!--��������4-->
	 	 	<cell><![CDATA[&nbsp;<%=ht2.get("CAR_NM")%> ]]></cell><!--����5-->
	 		<cell><![CDATA[&nbsp;<%=ht2.get("OPT")%> ]]></cell><!--���6-->
			<cell><![CDATA[<%=ht2.get("COLO")%> ]]></cell><!--�������7-->			
	 	 	<cell><![CDATA[<%=ht2.get("IN_COL")%> ]]></cell><!--�������8-->
	 	 	<cell><![CDATA[<%=ht2.get("BLUE_COL")%>]]></cell><!--����÷��ѿ���9-->
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht2.get("CAR_AMT")))%>]]></cell><!--�Һ��ڰ�10-->	
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht2.get("DLV_EST_DT")))%><%if(!acar_de.equals("1000")){%> <%=ht2.get("AGENT_VIEW_YN")%><%}%>]]></cell><!--�������11-->
	 		<cell><![CDATA[<%=ht2.get("BUS_NM")%>]]></cell><!--������12-->
	 		<cell><![CDATA[<%=ht2.get("STATUS")%>]]></cell><!--���౸��13-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht2.get("RES_REG_DT")))%>]]></cell><!--������14-->
	 		<cell><![CDATA[<%if(ht2.get("RES_END_DT") != null ){%> <%=AddUtil.ChangeDate2(String.valueOf(ht2.get("RES_END_DT")))%> <%}%>]]></cell><!--�����ϸ�����-->
	 		<cell><![CDATA[<%=AddUtil.subData(String.valueOf(ht2.get("FIRM_NM")), 12)%><%if(String.valueOf(ht2.get("CUST_Q")).equals("Q")){%>Q<%}%>]]></cell><!--����ȣ15-->
	 		<cell><![CDATA[<%=AddUtil.subData(String.valueOf(ht2.get("ADDR")), 7)%>]]></cell><!--���ּ�16-->
	 		<cell><![CDATA[<%=ht2.get("CUST_TEL")%>]]></cell><!--������ó17-->
	 		<cell><![CDATA[<%=ht2.get("MEMO")%>]]></cell><!--�޸�18-->
	 		<cell><![CDATA[<%=ht2.get("RENT_L_CD")%>]]></cell><!--����ȣ19-->
	 		<cell><![CDATA[<%=bus_nm2%><%//=ht2.get("BUS_NM2")%>]]></cell><!--2���� ������-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht2.get("DLV_DT")))%>]]></cell><!--�����20-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht2.get("CLS_DT")))%>]]></cell><!--�������������21-->
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht2.get("CON_AMT")))%>]]></cell><!--����22-->
	 	 	<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht2.get("CON_PAY_DT")))%>]]></cell><!--����������23-->
	 	</row>
<%		}	
	}	%>
<%	if(vt3.size() > 0){%>
<%		for(int i = 0 ; i < vt3.size() ; i++){
			Hashtable ht3 = (Hashtable)vt3.elementAt(i);
			com_con_no = String.valueOf(ht3.get("COM_CON_NO"))+"^javascript:view_cont(&#39;"+ht3.get("SEQ")+"&#39;);^_self";
			
			//������Ʈ�� ������Ʈ ���� ���̱⸸ ����
			if(acar_de.equals("1000") && !String.valueOf(ht3.get("AGENT_VIEW_YN")).equals("Y") ){
				continue;
			}
			
			row_cnt ++;
			
			String engine3 = "";
			if (ht3.get("ECO_YN").equals("0")) {
				engine3 = "���ָ�����";
			} else if (ht3.get("ECO_YN").equals("1")) {
				engine3 = "��������";
			} else if (ht3.get("ECO_YN").equals("2")) {
				engine3 = "LPG����";
			} else if (ht3.get("ECO_YN").equals("3")) {
				engine3 = "���̺긮��";
			} else if (ht3.get("ECO_YN").equals("4")) {
				engine3 = "�÷����� ���̺긮��";
			} else if (ht3.get("ECO_YN").equals("5")) {
				engine3 = "������";
			} else if (ht3.get("ECO_YN").equals("6")) {
				engine3 = "������";
			}
			
			bus_nm2 = "";
			bus_nm3 = "";
			
			//�����ڰ� ������ ������ ������ ���� �����´�.
			if (!String.valueOf(ht3.get("BUS_NM")).equals("")) {
				//�����ڸ���Ʈ
				Vector res_vt = cop_db.getCarOffPreSeqResUseList(String.valueOf(ht3.get("SEQ")));
				int res_vt_size = res_vt.size();
				if(res_vt_size>1){
					for(int j = 0 ; j < res_vt_size ; j++){
						Hashtable res_ht = (Hashtable)res_vt.elementAt(j);
						if(j==1){
							bus_nm2 = String.valueOf(res_ht.get("BUS_NM"));
						}
						if(j==2){
							bus_nm3 = String.valueOf(res_ht.get("BUS_NM"));
						}
					}	
				}				
			}
			
%>	
		<row  id='<%=row_cnt%>' style="<%if(String.valueOf(ht3.get("PRE_OUT_YN")).equals("Y")){%>background-color:#FFD4DF;<%}%>
									   <%if(i==0){%>border-top:3px solid #B4B4FF;<%}%>">
			<cell><![CDATA[<%=row_cnt%>]]></cell><!--����0-->
 	 		<cell><![CDATA[<%=ht3.get("CAR_OFF_NM")%>]]></cell><!--�������1-->
 	 		<cell><![CDATA[<%if(String.valueOf(ht3.get("BUS_SELF_YN")).equals("Y")){%>��ü����<%if(!String.valueOf(ht3.get("Q_REG_DT")).equals("")){%>Q<%}%><%}%>]]></cell><!--��ü��������-->
	 	 	<cell><![CDATA[<%=com_con_no%>]]></cell><!--�����ȣ2-->
 	 		<%-- <cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>]]></cell> --%><!--����Ͻ�3-->
 	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht3.get("REQ_DT")))%>]]></cell><!--��û�Ͻ�3-->
 	 		<cell><![CDATA[<%=engine3%>]]></cell><!--��������4-->
	 	 	<cell><![CDATA[&nbsp;<%=ht3.get("CAR_NM")%> ]]></cell><!--����5-->
	 		<cell><![CDATA[&nbsp;<%=ht3.get("OPT")%> ]]></cell><!--���6-->
			<cell><![CDATA[<%=ht3.get("COLO")%> ]]></cell><!--�������7-->			
	 	 	<cell><![CDATA[<%=ht3.get("IN_COL")%> ]]></cell><!--�������8-->
	 	 	<cell><![CDATA[<%=ht3.get("BLUE_COL")%>]]></cell><!--����÷��ѿ���9-->
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht3.get("CAR_AMT")))%>]]></cell><!--�Һ��ڰ�10-->	
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht3.get("DLV_EST_DT")))%><%if(!acar_de.equals("1000")){%> <%=ht3.get("AGENT_VIEW_YN")%><%}%>]]></cell><!--�������11-->
	 		<cell><![CDATA[<%=ht3.get("BUS_NM")%>]]></cell><!--������12-->
	 		<cell><![CDATA[<%=ht3.get("STATUS")%>]]></cell><!--���౸��13-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht3.get("RES_REG_DT")))%>]]></cell><!--������14-->
	 		<cell><![CDATA[<%if(ht3.get("RES_END_DT") != null ){%> <%=AddUtil.ChangeDate2(String.valueOf(ht3.get("RES_END_DT")))%> <%}%>]]></cell><!--�����ϸ�����-->
	 		<cell><![CDATA[<%=AddUtil.subData(String.valueOf(ht3.get("FIRM_NM")), 12)%><%if(String.valueOf(ht3.get("CUST_Q")).equals("Q")){%>Q<%}%>]]></cell><!--����ȣ15-->
	 		<cell><![CDATA[<%=AddUtil.subData(String.valueOf(ht3.get("ADDR")), 7)%>]]></cell><!--���ּ�16-->
	 		<cell><![CDATA[<%=ht3.get("CUST_TEL")%>]]></cell><!--������ó17-->
	 		<cell><![CDATA[<%=ht3.get("MEMO")%>]]></cell><!--�޸�18-->
	 		<cell><![CDATA[<%=ht3.get("RENT_L_CD")%>]]></cell><!--����ȣ19-->
	 		<cell><![CDATA[<%=bus_nm2%><%//=ht3.get("BUS_NM2")%>]]></cell><!--2���� ������-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht3.get("DLV_DT")))%>]]></cell><!--�����20-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht3.get("CLS_DT")))%>]]></cell><!--�������������21-->
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht3.get("CON_AMT")))%>]]></cell><!--����22-->
	 	 	<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht3.get("CON_PAY_DT")))%>]]></cell><!--����������23-->
	 	</row>
<%		}	
	}	%>
<%	if(vt4.size() > 0){%>
<%		for(int i = 0 ; i < vt4.size() ; i++){
			Hashtable ht4 = (Hashtable)vt4.elementAt(i);
			com_con_no = String.valueOf(ht4.get("COM_CON_NO"))+"^javascript:view_cont(&#39;"+ht4.get("SEQ")+"&#39;);^_self";
			
			//������Ʈ�� ������Ʈ ���� ���̱⸸ ����
			if(acar_de.equals("1000") && !String.valueOf(ht4.get("AGENT_VIEW_YN")).equals("Y") ){
				continue;
			}
			
			row_cnt ++;
			
			String engine4 = "";
			if (ht4.get("ECO_YN").equals("0")) {
				engine4 = "���ָ�����";
			} else if (ht4.get("ECO_YN").equals("1")) {
				engine4 = "��������";	
			} else if (ht4.get("ECO_YN").equals("2")) {
				engine4 = "LPG����";	
			} else if (ht4.get("ECO_YN").equals("3")) {
				engine4 = "���̺긮��";	
			} else if (ht4.get("ECO_YN").equals("4")) {
				engine4 = "�÷����� ���̺긮��";	
			} else if (ht4.get("ECO_YN").equals("5")) {
				engine4 = "������";	
			} else if (ht4.get("ECO_YN").equals("6")) {
				engine4 = "������";	
			}
			
			bus_nm2 = "";
			bus_nm3 = "";
			
			//�����ڰ� ������ ������ ������ ���� �����´�.
			if (!String.valueOf(ht4.get("BUS_NM")).equals("")) {
				//�����ڸ���Ʈ
				Vector res_vt = cop_db.getCarOffPreSeqResUseList(String.valueOf(ht4.get("SEQ")));
				int res_vt_size = res_vt.size();
				if(res_vt_size>1){
					for(int j = 0 ; j < res_vt_size ; j++){
						Hashtable res_ht = (Hashtable)res_vt.elementAt(j);
						if(j==1){
							bus_nm2 = String.valueOf(res_ht.get("BUS_NM"));
						}
						if(j==2){
							bus_nm3 = String.valueOf(res_ht.get("BUS_NM"));
						}
					}	
				}				
			}
			
%>	
		<row  id='<%=row_cnt%>' style="<%if(String.valueOf(ht4.get("PRE_OUT_YN")).equals("Y")){%>background-color:#FFD4DF;<%}%>
									   <%if(i==0){%>border-top:3px solid #B4B4FF;<%}%>">
			<cell><![CDATA[<%=row_cnt%>]]></cell><!--����0-->
 	 		<cell><![CDATA[<%=ht4.get("CAR_OFF_NM")%>]]></cell><!--�������1-->
 	 		<cell><![CDATA[<%if(String.valueOf(ht4.get("BUS_SELF_YN")).equals("Y")){%>��ü����<%if(!String.valueOf(ht4.get("Q_REG_DT")).equals("")){%>Q<%}%><%}%>]]></cell><!--��ü��������-->
	 	 	<cell><![CDATA[<%=com_con_no%>]]></cell><!--�����ȣ2-->
 	 		<%-- <cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>]]></cell> --%><!--����Ͻ�3-->
 	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht4.get("REQ_DT")))%>]]></cell><!--��û�Ͻ�3-->
 	 		<cell><![CDATA[<%=engine4%>]]></cell><!--��������4-->
	 	 	<cell><![CDATA[&nbsp;<%=ht4.get("CAR_NM")%> ]]></cell><!--����5-->
	 		<cell><![CDATA[&nbsp;<%=ht4.get("OPT")%> ]]></cell><!--���6-->
			<cell><![CDATA[<%=ht4.get("COLO")%> ]]></cell><!--�������7-->			
	 	 	<cell><![CDATA[<%=ht4.get("IN_COL")%> ]]></cell><!--�������8-->
	 	 	<cell><![CDATA[<%=ht4.get("BLUE_COL")%>]]></cell><!--����÷��ѿ���9-->
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht4.get("CAR_AMT")))%>]]></cell><!--�Һ��ڰ�10-->	
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht4.get("DLV_EST_DT")))%><%if(!acar_de.equals("1000")){%> <%=ht4.get("AGENT_VIEW_YN")%><%}%>]]></cell><!--�������11-->
	 		<cell><![CDATA[<%=ht4.get("BUS_NM")%>]]></cell><!--������12-->
	 		<cell><![CDATA[<%=ht4.get("STATUS")%>]]></cell><!--���౸��13-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht4.get("RES_REG_DT")))%>]]></cell><!--������14-->
	 		<cell><![CDATA[<%if(ht4.get("RES_END_DT") != null ){%> <%=AddUtil.ChangeDate2(String.valueOf(ht4.get("RES_END_DT")))%> <%}%>]]></cell><!--�����ϸ�����-->
	 		<cell><![CDATA[<%=AddUtil.subData(String.valueOf(ht4.get("FIRM_NM")), 12)%><%if(String.valueOf(ht4.get("CUST_Q")).equals("Q")){%>Q<%}%>]]></cell><!--����ȣ15-->
	 		<cell><![CDATA[<%=AddUtil.subData(String.valueOf(ht4.get("ADDR")), 7)%>]]></cell><!--���ּ�16-->
	 		<cell><![CDATA[<%=ht4.get("CUST_TEL")%>]]></cell><!--������ó17-->
	 		<cell><![CDATA[<%=ht4.get("MEMO")%>]]></cell><!--�޸�18-->
	 		<cell><![CDATA[<%=ht4.get("RENT_L_CD")%>]]></cell><!--����ȣ19-->
	 		<cell><![CDATA[<%=bus_nm2%><%//=ht4.get("BUS_NM2")%>]]></cell><!--2���� ������-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht4.get("DLV_DT")))%>]]></cell><!--�����20-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht4.get("CLS_DT")))%>]]></cell><!--�������������21-->
			<cell><![CDATA[<%=AddUtil.parseDecimal(String.valueOf(ht4.get("CON_AMT")))%>]]></cell><!--����22-->
	 	 	<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht4.get("CON_PAY_DT")))%>]]></cell><!--����������23-->
	 	</row>
<%		}	
	}	%>
 
</rows>
