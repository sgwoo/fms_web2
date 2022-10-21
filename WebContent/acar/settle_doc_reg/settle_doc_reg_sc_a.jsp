<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	/* multipart/form-data �� FileUpload��ü ���� */ 
	
	String savePath = "C:\\Inetpub\\wwwroot\\data\\stop_doc"; // ������ ���丮 (������)
 	int sizeLimit = 5 * 1024 * 1024 ; // 5�ް����� ���� �Ѿ�� ���ܹ߻�
	MultipartRequest multi=new MultipartRequest(request, savePath, sizeLimit);
	
	String auth_rw 	= multi.getParameter("auth_rw")==null?"":multi.getParameter("auth_rw");
	String user_id	= multi.getParameter("user_id")==null?"":multi.getParameter("user_id");//�α���-ID
	String br_id 	= multi.getParameter("br_id")==null?"":multi.getParameter("br_id");//�α���-������
	
		
%>

<%
	String doc_id 	= multi.getParameter("doc_id")==null?"":multi.getParameter("doc_id");
	String gov_nm 	= multi.getParameter("gov_nm")==null?"":multi.getParameter("gov_nm");
	String gov_addr = multi.getParameter("gov_addr")==null?"":multi.getParameter("gov_addr");
	String mng_dept = multi.getParameter("mng_dept")==null?"":multi.getParameter("mng_dept");
	String title 	= multi.getParameter("title")==null?"":multi.getParameter("title");
	String title_sub= multi.getParameter("title_sub")==null?"":multi.getParameter("title_sub");
	
	//�ѱ��� ������ ���� -multipartrequest
    doc_id		= new String(doc_id.getBytes("8859_1"),"euc-kr");
    gov_nm		= new String(gov_nm.getBytes("8859_1"),"euc-kr");
    gov_addr	= new String(gov_addr.getBytes("8859_1"),"euc-kr");
    mng_dept	= new String(mng_dept.getBytes("8859_1"),"euc-kr");
    title		= new String(title.getBytes("8859_1"),"euc-kr");
    title_sub	= new String(title_sub.getBytes("8859_1"),"euc-kr");
	
	int count = 0;
	boolean flag = true;
	int flag1 = 0;
	
	//�ߺ�üũ
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){
		//�ְ��� ���̺�
		FineDocBn.setDoc_id		(doc_id);
		FineDocBn.setDoc_dt		(multi.getParameter("doc_dt")==null?"":multi.getParameter("doc_dt"));
		FineDocBn.setGov_id		(multi.getParameter("gov_id")==null?"":multi.getParameter("gov_id"));
		FineDocBn.setMng_dept	(mng_dept);
		FineDocBn.setReg_id		(user_id);
		FineDocBn.setGov_nm		(gov_nm);
		FineDocBn.setGov_addr	(gov_addr);
		FineDocBn.setTitle		(title);
		if(title.equals("��Ÿ")){
			FineDocBn.setTitle		(title_sub);
		}
		FineDocBn.setEnd_dt		(multi.getParameter("end_dt")==null?"":multi.getParameter("end_dt"));
		
		Enumeration formNames=multi.getFileNames();  // ���� �̸� ��ȯ
		String formName=(String)formNames.nextElement(); // �ڷᰡ ���� ��쿣 while ���� ���
		String fileName=multi.getFilesystemName(formName)==null?"":multi.getFilesystemName(formName); // ������ �̸� ���
		if(!fileName.equals("")){
			FineDocBn.setFilename	(fileName);
		}
		
		flag = FineDocDb.insertFineDoc(FineDocBn);


		//�̼�ä�Ǹ���Ʈ
		
		int size 			= multi.getParameter("size")==null?0:AddUtil.parseDigit(multi.getParameter("size"));
		String tax_yn 		= multi.getParameter("tax_yn")==null?"N":multi.getParameter("tax_yn");
		String ch_l_cd[]	= new String[size];
		int seq = 0;
		
		for(int i=0; i<size; i++){
			
			ch_l_cd[i] 		= multi.getParameter("ch_l_cd_"+i)==null?"N":multi.getParameter("ch_l_cd_"+i);
			
			if(ch_l_cd[i].equals("Y")){
				String m_id = multi.getParameter("m_id_"+i)==null?"":multi.getParameter("m_id_"+i);
				String l_cd = multi.getParameter("l_cd_"+i)==null?"":multi.getParameter("l_cd_"+i);
				String c_id = multi.getParameter("c_id_"+i)==null?"":multi.getParameter("c_id_"+i);
				
				FineDocListBn.setDoc_id			(doc_id);
				FineDocListBn.setSeq_no			(seq);
				FineDocListBn.setCar_mng_id		(c_id);
				FineDocListBn.setRent_mng_id	(m_id);
				FineDocListBn.setRent_l_cd		(l_cd);
				
				String car_no 	= multi.getParameter("car_no_"+i)==null?"":multi.getParameter("car_no_"+i);
				car_no			= new String(car_no.getBytes("8859_1"),"euc-kr");
				FineDocListBn.setCar_no			(car_no);
				
				FineDocListBn.setAmt1			(multi.getParameter("amt1_"+i) ==null?0: AddUtil.parseDigit(multi.getParameter("amt1_"+i)));
				FineDocListBn.setAmt2			(multi.getParameter("amt2_"+i) ==null?0: AddUtil.parseDigit(multi.getParameter("amt2_"+i)));
				FineDocListBn.setAmt3			(multi.getParameter("amt3_"+i) ==null?0: AddUtil.parseDigit(multi.getParameter("amt3_"+i)));
				FineDocListBn.setAmt4			(multi.getParameter("amt4_"+i) ==null?0: AddUtil.parseDigit(multi.getParameter("amt4_"+i)));
				FineDocListBn.setAmt5			(multi.getParameter("amt5_"+i) ==null?0: AddUtil.parseDigit(multi.getParameter("amt5_"+i)));
				FineDocListBn.setAmt6			(multi.getParameter("amt6_"+i) ==null?0: AddUtil.parseDigit(multi.getParameter("amt6_"+i)));
				FineDocListBn.setReg_id			(user_id);
				
				seq++;
				flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
				
				//���ݰ�꼭 ��������
				if(tax_yn.equals("Y")){
				
					//���ݰ�꼭 �����Ͻ������������� ����Ʈ
					Vector vt = af_db.getFeeScdStopList(m_id, l_cd);
					int vt_size = vt.size();
					
					FeeScdStopBean fee_scd = new FeeScdStopBean();
					
					fee_scd.setDoc_id		(doc_id);
					fee_scd.setRent_mng_id	(m_id);
					fee_scd.setRent_l_cd	(l_cd);
					fee_scd.setStop_st		(multi.getParameter("stop_st")==null?"":multi.getParameter("stop_st"));//��������
					fee_scd.setStop_s_dt	(multi.getParameter("stop_s_dt")==null?"":multi.getParameter("stop_s_dt"));//�����Ⱓ
					fee_scd.setStop_e_dt	(multi.getParameter("stop_e_dt")==null?"":multi.getParameter("stop_e_dt"));//�����Ⱓ
					
					String stop_cau 	= multi.getParameter("stop_cau")==null?"":multi.getParameter("stop_cau");
					stop_cau			= new String(stop_cau.getBytes("8859_1"),"euc-kr");
					fee_scd.setStop_cau		(stop_cau);//��������
					
					fee_scd.setStop_doc_dt	(multi.getParameter("doc_dt")==null?"":multi.getParameter("doc_dt"));//��������߽�����
					
					if(!fileName.equals("")){
						fee_scd.setStop_doc	(fileName);
					}
					
					fee_scd.setReg_id		(user_id);
					fee_scd.setSeq			(String.valueOf(vt_size+1));
					if(!af_db.insertFeeScdStop(fee_scd)) flag1 += 1;
				}
				
			}
		}
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(count == 0){%>
<%		if(flag==true){%>
			alert("���������� ó���Ǿ����ϴ�.");
			parent.parent.location.reload();			
<%		}else{%>
			alert("�����߻�!");
<%		}%>
<%	}else{%>
			alert("�̹� ��ϵ� ������ȣ�Դϴ�. Ȯ���Ͻʽÿ�.");
			parent.document.form1.gov_nm.focus();
<%	}%>
</script>
</body>
</html>

