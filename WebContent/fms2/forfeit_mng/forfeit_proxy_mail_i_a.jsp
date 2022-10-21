<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.admin.*,  acar.client.*,  acar.res_search.*,  acar.im_email.*, tax.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<% 
	//�α��� ���������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	int flag1 = 0;
	int count = 0;	
	String gubun1 	= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] chk_cd = request.getParameterValues("ch_l_cd");

	String vid_num="";
	
	String ch_m_id="";  
	String ch_l_cd="";
	String ch_c_id="";
	String ch_seq_no="";
	String ch_cust_nm="";		
	String ch_dem_dt="";		
	String ch_e_dem_dt="";		
	String ch_gubun="";
		
	String subject 		= "";
	String msg 			= "";
	String sendname 	= "(��)�Ƹ���ī";
	String sendphone 	= "02-392-4242";
	String email 		= "";
	int seqidx			= 0;	
	String gov_nm = "";	
	
	//���·�����
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
		
		//�Ľ�
	for(int i=0; i<chk_cd.length;i++){
		vid_num=chk_cd[i];
		
	//	System.out.println("vid_num="+vid_num);
			
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_m_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();	 
				ch_seq_no = token1.nextToken().trim();	
				ch_cust_nm = token1.nextToken().trim();	//�ӿ����̻�
				ch_dem_dt = token1.nextToken().trim();	//�������·� û����
				ch_e_dem_dt = token1.nextToken().trim(); //�������·� û���� ������
		}	
	
		//cont_view
		Hashtable base = ad_db.getContEmail(ch_m_id, ch_l_cd);	
		
		if (!ch_cust_nm.equals("$$")) {
			gov_nm = ch_cust_nm;
		} else {
			gov_nm = String.valueOf(base.get("FIRM_NM"));
		}		
		
		email = String.valueOf(base.get("EMAIL"));
		
		ch_dem_dt = AddUtil.getReplace_dt(ch_dem_dt);
		ch_e_dem_dt = AddUtil.getReplace_dt(ch_e_dem_dt);
		
		//�ϴ� test	
	//	email = "dev@amazoncar.co.kr";


		   //���·� ����  - �ܱ�뿩���� ����
		f_bean = a_fdb.getForfeitDetailAll(ch_c_id, ch_m_id, ch_l_cd, ch_seq_no);
		
			//�����̿��
		if(!f_bean.getRent_s_cd().equals("")){//����ý��� ��� �����̸�
			//�ܱ�������
			RentContBean rc_bean = rs_db.getRentContCase(f_bean.getRent_s_cd(), ch_c_id);
			//������
			RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
			
			//�������� ���
			String rent_st = rc_bean.getRent_st();  //��������
			String org_l_cd = rc_bean.getSub_l_cd();
			String org_m_id = "";;
			
			if(rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("10")){
			
				//�ŷ�ó����
		        
				ClientBean client = al_db.getNewClient(rc_bean.getCust_id());
				gov_nm = client.getFirm_nm();
				
				org_m_id = ad_db.getRent_mng_id(org_l_cd );
				
				//cont_view
				Hashtable base2 = ad_db.getContEmail(org_m_id, org_l_cd);
				email = String.valueOf(base2.get("EMAIL"));					
			}
		
		}
				
		// ���·ῡ �߼��� ����
	 	if(!a_fdb.updateForfeitPrintDemDt(ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no), user_id)) flag1 += 1;
	 			
		subject 		= gov_nm+"��, �������·� (�����)û���� �Դϴ�.";
		msg 			= gov_nm+"��, �������·� (�����)û���� �Դϴ�.";
		
		//�ŷ�ó ������ ������
		
		if(!email.equals("") && !ch_gubun.equals(ch_m_id+ch_l_cd+ch_dem_dt+ch_e_dem_dt) ){
			//	1. d-mail ���-------------------------------
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"�Ƹ���ī\"<tax300@amazoncar.co.kr>");
			d_bean.setMailto			("\""+gov_nm+"\"<"+email.trim()+">");
			d_bean.setReplyto			("\"�Ƹ���ī\"<tax300@amazoncar.co.kr>");
			d_bean.setErrosto			("\"�Ƹ���ī\"<tax300@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				("fine");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin����
			d_bean.setG_idx				(1);//admin����
			d_bean.setMsgflag     		(0);	
		
			d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_bill.jsp?m_id="+ch_m_id+"&l_cd="+ch_l_cd+"&dem_dt="+ch_dem_dt+"&e_dem_dt="+ch_e_dem_dt);
					

			seqidx = ImEmailDb.insertDEmail3(d_bean, "4", "", "+7", ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no));
		    ch_gubun = ch_m_id + ch_l_cd + ch_dem_dt + ch_e_dem_dt;
		    count++;			
		}
		
//	   System.out.println("mail_i ch_m_id=" +ch_m_id + "|ch_l_cd=" + ch_l_cd + "|ch_dem_dt=" + ch_dem_dt+"|ch_e_dem_dt="+ch_e_dem_dt);
	  
	}	
	
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(count >= 1){%>
	alert("����Ǿ����ϴ�.");	
//	parent.location.href='forfeit_de_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&gubun1=2&gubun2=<%=gubun2%>';
	parent.location.href = "forfeit_de_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&gubun1=2&gubun2=<%=gubun2%>";

<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
<%}%>
//-->
</script>
</body>
</html>