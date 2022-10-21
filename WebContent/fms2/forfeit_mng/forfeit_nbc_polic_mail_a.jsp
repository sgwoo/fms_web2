<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.admin.*,  acar.client.*,  acar.res_search.*,  acar.im_email.*, tax.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	

//	String email 	= request.getParameter("email")==null?"":request.getParameter("email");
	
	int flag1 = 0;

	int result = 0;
	
	//���·�����
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");		
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String res_firm = request.getParameter("res_firm")==null?"":request.getParameter("res_firm");
	
	String dem_dt = request.getParameter("dem_dt")==null?"":request.getParameter("dem_dt");
	String e_dem_dt = request.getParameter("e_dem_dt")==null?"":request.getParameter("e_dem_dt");
	
	
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
	
	
	String ck_m_id1 = "";
	String ck_m_id2 = "";
	String ck_m_id3 = "";
	
	
	for(int i=0; i<chk_cd.length;i++){
		vid_num=chk_cd[i];
		
	//System.out.println("vid_num="+vid_num);
			
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
	
	if(ch_e_dem_dt.equals("")||ch_e_dem_dt.equals("null")){
			ch_e_dem_dt = AddUtil.getDate();
		}
		
		ck_m_id1 = ch_m_id ;
		
		if(ck_m_id2 == ck_m_id1){  //�ߺ�üũ- ������ �н�
		
		//System.out.println("ck_m_id1="+ck_m_id1);
		//System.out.println("ck_m_id2="+ck_m_id2);
		
		}else{//�ߺ�üũ - �ٸ��� �Ʒ��ڵ� ����.
			ck_m_id2 = ck_m_id1;
		
	
	
	

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

	
	
	if(seq_no.equals("")){//���� ���·� �����ں��� ����ϰ� ���� ������ ������ ��ȣ ��������.
		Hashtable ht = a_fdb.getForfeitSeq_no(c_id, m_id, l_cd);
		seq_no = String.valueOf(ht.get("SEQ_NO"));
	}	
	
//System.out.println("seq_no: "+seq_no);

   //���·� ����  - �ܱ�뿩���� ����
		f_bean = a_fdb.getForfeitDetailAll(ch_c_id, ch_m_id, ch_l_cd, ch_seq_no);
		ch_e_dem_dt = (String)f_bean.getE_dem_dt();//��ݿ��� ��Ͻ� �Էµ� ��¥�� ��ȸ�ؼ� ������. 
		
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

				//�ϴ� test	
				//email = "gillsun@naver.com";
				
			}
		
		}
	
	
//	if(gov_nm.equals("�ֽ�ȸ�� ������Ż")){//2012.10.26�� ���� ��û���� ���Ͽ� ������ �߼����� �ʵ��� ��.
//		email = "koobuk@gmail.com";
//	}else{
//		email = String.valueOf(base.get("EMAIL"));
//	}


	String file_name1 = request.getParameter("file_name")==null?"":request.getParameter("file_name");
	String file_name2 = request.getParameter("file_name2")==null?"":request.getParameter("file_name2");
	int idx			= 0;	
	int fcnt = 0;
	if(!file_name1.equals("")){
		fcnt ++;
	}
	if(!file_name2.equals("")){
		fcnt ++;
	}

	dem_dt = AddUtil.getReplace_dt(dem_dt);
	
	e_dem_dt = AddUtil.getDate(); //���������Ϸΰ��ŵ�. 
	e_dem_dt = AddUtil.getReplace_dt(e_dem_dt);
	
	// ���·ῡ �߼��� ����
	if(!a_fdb.updateForfeitPrintDemDt(ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no), user_id)) flag1 += 1;
		
	//�ϴ� test	
	//System.out.println("email: "+email);
	//email = "gillsun@naver.com";	
	
	subject 		= gov_nm+"��, ������ ���·� �����ں��� �����ȳ� �Դϴ�.";
	msg 			= gov_nm+"��, ������ ���·� �����ں��� �����ȳ� �Դϴ�.";
		
	if(!email.equals("") && !email.equals("null")){
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
			d_bean.setEncoding			(3);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(fcnt);
			d_bean.setGubun				("fine_bill_nbc_polic");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin����
			d_bean.setG_idx				(fcnt);//admin����
			d_bean.setMsgflag     		(0);
		
			d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_bill_nbc.jsp?m_id="+ch_m_id+"&l_cd="+ch_l_cd+"&c_id="+ch_c_id+"&dem_dt="+ch_dem_dt+"&e_dem_dt="+ch_dem_dt+"&seq_no="+Util.parseInt(ch_seq_no));
	
		   	
			seqidx = ImEmailDb.insertDEmail3(d_bean, "4", "", "+7", ch_c_id, ch_m_id, ch_l_cd, Util.parseInt(ch_seq_no));
			
	

//System.out.println("http://fms1.amazoncar.co.kr/mailing/rent/email_fine_bill_nbc.jsp?m_id="+ch_m_id+"&l_cd="+ch_l_cd+"&c_id="+ch_c_id+"&dem_dt="+ch_dem_dt+"&e_dem_dt="+ch_dem_dt+"&seq_no="+Util.parseInt(ch_seq_no));
		   
	}
	}
	}

%>

<script>
<%	if(seqidx > 0){%>
			alert("���������� ó���Ǿ����ϴ�.");
				
<%		}else{%>
			alert("�����߻�!");
<%		}%>

</script>

</body>
</html>