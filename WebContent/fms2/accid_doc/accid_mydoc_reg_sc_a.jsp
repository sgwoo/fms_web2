<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*,  tax.*, acar.cont.* "%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	AccidDatabase as_db = AccidDatabase.getInstance();

	String doc_id = FineDocDb.getFineGovNoNext("손해");
	
	int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
	
	int count = 0;
	boolean flag = true;
	int flag2 = 0;
	
	//중복체크
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){
		//공문 테이블
		FineDocBn.setDoc_id		(doc_id);
		FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
		FineDocBn.setGov_id		(request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
		FineDocBn.setGov_nm		(request.getParameter("gov_nm")==null?"":request.getParameter("gov_nm"));
		FineDocBn.setTitle		("손해배상금 청구");
		FineDocBn.setGov_st		(request.getParameter("ins_com")==null?"":request.getParameter("ins_com"));
		FineDocBn.setGov_zip	(request.getParameter("gov_zip")==null?"":request.getParameter("gov_zip"));
		FineDocBn.setGov_addr	(request.getParameter("gov_addr")==null?"":request.getParameter("gov_addr"));
		FineDocBn.setMng_dept	(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
		FineDocBn.setMng_pos	(request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos"));
		FineDocBn.setH_mng_id	(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
		FineDocBn.setB_mng_id	(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));
		FineDocBn.setApp_docs	(request.getParameter("app_docs")==null?"":request.getParameter("app_docs"));
		FineDocBn.setReg_id		(user_id);
		
		
		flag = FineDocDb.insertFineDoc(FineDocBn);
		
		//공문 리스트
		String car_mng_id[]	 	= request.getParameterValues("car_mng_id");
		String accid_id[] 		= request.getParameterValues("accid_id");
		String seq_no[] 		= request.getParameterValues("seq_no");  //휴대차료연번
		
		String rent_mng_id[]	= request.getParameterValues("rent_mng_id");
		String rent_l_cd[]		= request.getParameterValues("rent_l_cd");
		String rent_s_cd[]		= request.getParameterValues("rent_s_cd");
		
		String firm_nm[] 		= request.getParameterValues("firm_nm");
		String enp_no[] 		= request.getParameterValues("enp_no");
		String ssn[] 			= request.getParameterValues("ssn");
		
		String rent_start_dt[] 	= request.getParameterValues("rent_start_dt");
		String rent_end_dt[] 	= request.getParameterValues("rent_end_dt");
		String use_day[] 		= request.getParameterValues("use_day");
		String ins_num[] 		= request.getParameterValues("ins_num");
		
		String car_no[] 		= request.getParameterValues("car_no");
		String car_nm[] 		= request.getParameterValues("car_nm");
		
		String req_amt[] 		= request.getParameterValues("req_amt");
		String pay_amt[] 		= request.getParameterValues("pay_amt");
		String jan_amt[] 		= request.getParameterValues("jan_amt");
		
		String o_ins_num[] 		= request.getParameterValues("o_ins_num");
		String item_id[] 		= request.getParameterValues("item_id");
		String item_yn[] 		= request.getParameterValues("item_yn");
		
		
		
		for(int i=0; i<size; i++){
			FineDocListBn.setDoc_id			(doc_id);
			FineDocListBn.setCar_mng_id		(car_mng_id[i]);
			FineDocListBn.setSeq_no			(i + 1);  //fine_doc_list 연번
			FineDocListBn.setRent_mng_id	(rent_mng_id[i]);
			FineDocListBn.setRent_l_cd		(rent_l_cd[i]);
			FineDocListBn.setRent_s_cd		(accid_id[i]);
			
			FineDocListBn.setFirm_nm		(firm_nm[i]==null?"":firm_nm[i]);
			FineDocListBn.setEnp_no			(enp_no[i]==null?"":enp_no[i]);
			FineDocListBn.setSsn			(ssn[i]==null?"":ssn[i]);
			
			FineDocListBn.setCar_no			(car_no[i]==null?"":car_no[i]);
			FineDocListBn.setRent_start_dt	(rent_start_dt[i]==null?"":rent_start_dt[i]);
			FineDocListBn.setRent_end_dt	(rent_end_dt[i]==null?"":rent_end_dt[i]);
			FineDocListBn.setPaid_no		(ins_num[i]==null?"":ins_num[i]);
			
			FineDocListBn.setVar1			(seq_no[i]==null?"":seq_no[i]);
			FineDocListBn.setVar2			(use_day[i]==null?"":use_day[i]);
			FineDocListBn.setVar3			(car_nm[i]==null?"":car_nm[i]);
			
			FineDocListBn.setAmt1			(req_amt[i]==null?0:AddUtil.parseDigit(req_amt[i]));  //청구액
			FineDocListBn.setAmt2			(pay_amt[i]==null?0:AddUtil.parseDigit(pay_amt[i]));  // 입금액
			FineDocListBn.setAmt3			(jan_amt[i]==null?0:AddUtil.parseDigit(jan_amt[i]));  // 차액
			
			FineDocListBn.setReg_id			(ck_acar_id);
			
			flag = FineDocDb.insertAccidDocList(FineDocListBn, FineDocBn.getDoc_dt());
			
			
			//사고접수번호 수정
			String old_ins_num = o_ins_num[i]==null?"":o_ins_num[i];
			String new_ins_num = ins_num[i]==null?"":ins_num[i];
			
			
			MyAccidBean myaccid_bean = as_db.getMyAccid(car_mng_id[i], accid_id[i], AddUtil.parseInt(seq_no[i]));
			int myaccid_count = as_db.updateMyAccidDocRegDt(myaccid_bean);
			
			
			if(old_ins_num.equals("") && !new_ins_num.equals("")){
				MyAccidBean ma_bean = as_db.getMyAccid(car_mng_id[i], accid_id[i], AddUtil.parseInt(seq_no[i]));
				ma_bean.setIns_num(new_ins_num);//보험사접수번호
				count = as_db.updateMyAccid(ma_bean);
			}
			
			//청구서발행
			String t_item_id = item_id[i]==null?"":item_id[i];
			String t_item_yn = item_yn[i]==null?"":item_yn[i];
			
			if(t_item_id.equals("") && t_item_yn.equals("Y")){
				MyAccidBean ma_bean = as_db.getMyAccid(car_mng_id[i], accid_id[i], AddUtil.parseInt(seq_no[i]));
				
				//[1단계] 거래명세서 생성----------------------------------------------------------------
				
				//실행코드 가져오기
				String reg_code  = Long.toString(System.currentTimeMillis());
				
				//사용할 item_id 가져오기
				String next_item_id = IssueDb.getItemIdNext(ma_bean.getIns_req_dt());
				
				TaxItemListBean til_bean = new TaxItemListBean();
				
				til_bean.setItem_id		(next_item_id);
				til_bean.setItem_seq	(1);
				til_bean.setItem_g		("대차료");
				til_bean.setItem_car_no	(car_no[i]==null?"":car_no[i]);
				til_bean.setItem_car_nm	(car_nm[i]==null?"":car_nm[i]);
				til_bean.setItem_dt1	(rent_start_dt[i]==null?"":rent_start_dt[i]);
				til_bean.setItem_dt2	(rent_end_dt[i]==null?"":rent_end_dt[i]);
				til_bean.setItem_supply	(ma_bean.getMc_s_amt());
				til_bean.setItem_value	(ma_bean.getMc_v_amt());
				til_bean.setRent_l_cd	(rent_l_cd[i]);
				til_bean.setCar_mng_id	(car_mng_id[i]);
				til_bean.setTm			(accid_id[i]);
		 		til_bean.setGubun		("11");
				til_bean.setReg_id		(user_id);
				til_bean.setReg_code	(reg_code);
				til_bean.setRent_seq	(seq_no[i]);
				til_bean.setItem_dt		(ma_bean.getIns_req_dt());
				
				//휴차료
				if(ma_bean.getIns_req_gu().equals("1")){
					til_bean.setItem_g	("휴차료");
					til_bean.setGubun	("12");
					til_bean.setItem_value	(0);
				}
				
				if(!IssueDb.insertTaxItemList(til_bean)) flag2 += 1;
				
				//계약:고객관련
				ContBaseBean base 		= a_db.getContBaseAll(rent_mng_id[i], rent_l_cd[i]);
				String site_id = "";
				if(base.getTax_type().equals("2")){//지점
					site_id = base.getR_site();
				}else{
					site_id = "";
				}
				
				//[2단계] 거래명세서 생성
				Vector vt = IssueDb.getTaxItemListSusi(reg_code);
				int vt_size = vt.size();
				for(int j=0;j < vt_size;j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					TaxItemBean ti_bean = new TaxItemBean();
					ti_bean.setClient_id	(base.getClient_id());
					ti_bean.setSeq			(site_id);
					ti_bean.setItem_dt		(ma_bean.getIns_req_dt());
					ti_bean.setTax_id		("");
					ti_bean.setItem_id		(String.valueOf(ht.get("ITEM_ID")));
					ti_bean.setItem_hap_str	(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
					ti_bean.setItem_hap_num	(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
					ti_bean.setItem_man		(String.valueOf(ht.get("ITEM_MAN")));
					
					if(!IssueDb.insertTaxItem(ti_bean)) flag2 += 1;
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
			alert("정상적으로 처리되었습니다.");
			parent.parent.location.reload();			
<%		}else{%>
			alert("에러발생!");
<%		}%>
<%	}else{%>
			alert("이미 등록된 문서번호입니다. 확인하십시오.");
//			parent.document.form1.gov_nm.focus();
<%	}%>
</script>
</body>
</html>

