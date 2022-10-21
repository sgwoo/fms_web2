<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
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
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
%>


<%
	String vid[] 	= request.getParameterValues("ch_cd");
	String vid_num 	= "";
	String tint_no 	= "";
	String off_id 	= "";
	String seq = "";
	int vid_size = vid.length;
	String value[] = new String[10];
	
		
	
	for(int i=0;i < vid_size;i++){
	
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		tint_no 		= value[0];
		off_id 			= value[1];
	
		String req_code  = Long.toString(System.currentTimeMillis());
		

		
		//1. 용품의뢰 수정-------------------------------------------------------------------------------------------
		
		//용품관리
		TintBean tint 	= t_db.getCarTint(tint_no);
				
		
		
		//2. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		String sub 	= "용품의뢰";
		String cont 	= "[용품번호:"+tint_no+"] 용품의뢰 합니다.";
		String target_id = user_id;
		
		if(tint.getOff_id().equals("002849")) 		target_id = "000103";				//다옴방
		if(tint.getOff_id().equals("008514")) 		target_id = nm_db.getWorkAuthUser("광주지점장");//대호4WD상사-광주지점->
		if(tint.getOff_id().equals("008680")) 		target_id = "000255";//용용이자동차용품점-광주지점
		if(tint.getOff_id().equals("002850")) 		target_id = "000121";//유림카랜드-부산출납->최은숙
		if(tint.getOff_id().equals("008692")) 		target_id = "000067";//오토카샵-대전지점장->길기주		
		if(tint.getOff_id().equals("008501")) 		target_id = "000054";//아시아나상사-대구지점->심재홍->윤영탁
		if(tint.getOff_id().equals("010255")) 		target_id = "000263";//스마일TS
		if(tint.getOff_id().equals("010613")) 		target_id = nm_db.getWorkAuthUser("본사관리팀장");//젤존코리아-블랙박스대량구입처
		if(tint.getOff_id().equals("010937")) 		target_id = "000289";//미성테크-대전지점
		

				
		
		

		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st	("6");//용품의뢰
		doc.setDoc_id	(req_code);
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	("");
		doc.setUser_nm1	("의뢰");
		doc.setUser_nm2	("수신");
		doc.setUser_nm3	("정산");
		doc.setUser_nm4	("청구");
		doc.setUser_nm5	("확인");
		doc.setUser_nm6	("점검");
		doc.setUser_id1	(tint.getReg_id());
		doc.setUser_id2	(target_id);
		doc.setUser_id3	(target_id);
		doc.setUser_id4	(target_id);
		doc.setUser_id5	(tint.getReg_id());
		doc.setDoc_bit	("1");//수신단계
		doc.setDoc_step	("1");//기안
		
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		
		//=====[doc_settle] update=====
		doc = d_db.getDocSettleCommi("6", req_code);
		flag2 = d_db.updateDocSettle(doc.getDoc_no(), target_id, "2", "2");
		out.println("문서처리전 결재<br>");
		
		
		
		if(!tint.getReg_st().equals("A") && !tint.getRent_l_cd().equals("")){
		
			TintBean tint1 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "1");
			TintBean tint2 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "2");
			TintBean tint3 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "3");
			TintBean tint4 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "4");
			TintBean tint5 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "5");
			TintBean tint6 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "6");
			
			//=====[tint] update=====
			if(off_id.equals(tint1.getOff_id())&&tint1.getDoc_code().equals("")) 	flag1 = t_db.updateCarTintDocCode(tint1.getTint_no(), req_code);
			if(off_id.equals(tint2.getOff_id())&&tint2.getDoc_code().equals("")) 	flag1 = t_db.updateCarTintDocCode(tint2.getTint_no(), req_code);
			if(off_id.equals(tint3.getOff_id())&&tint3.getDoc_code().equals("")) 	flag1 = t_db.updateCarTintDocCode(tint3.getTint_no(), req_code);
			if(off_id.equals(tint4.getOff_id())&&tint4.getDoc_code().equals("")) 	flag1 = t_db.updateCarTintDocCode(tint4.getTint_no(), req_code);
			if(off_id.equals(tint5.getOff_id())&&tint5.getDoc_code().equals("")) 	flag1 = t_db.updateCarTintDocCode(tint5.getTint_no(), req_code);		
			if(off_id.equals(tint6.getOff_id())&&tint6.getDoc_code().equals("")) 	flag1 = t_db.updateCarTintDocCode(tint6.getTint_no(), req_code);		
		}else{
			//=====[tint] update=====
			flag1 = t_db.updateCarTintDocCode(tint_no, req_code);	
		}
		
		
		if(tint.getOff_id().equals("010613")){
			flag2 = d_db.updateDocSettle(doc.getDoc_no(), tint.getReg_id(), "2", "2");
			flag2 = d_db.updateDocSettle(doc.getDoc_no(), tint.getReg_id(), "3", "2");
			flag2 = d_db.updateDocSettle(doc.getDoc_no(), tint.getReg_id(), "6", "3");
			tint.setSup_dt		(tint.getSup_est_dt());
			tint.setReq_dt		(AddUtil.getDate());
			tint.setConf_dt		(AddUtil.getDate());
			if(tint.getTint_amt()==0){
				//tint.setTint_amt	(72727*tint.getTint_su());
				//tint.setTint_amt	(68181*tint.getTint_su());
				tint.setTint_amt	(65454*tint.getTint_su());				
				tint.setR_tint_amt(tint.getTint_amt());
			}
			//=====[tint] update=====
			flag1 = t_db.updateCarTint(tint);
		}
		if(tint.getOff_id().equals("011281")){	//이동형충전기(파워큐브코리아)는 바로 문서결제4단계까지 (2018.04.25)
			flag2 = d_db.updateDocSettle(doc.getDoc_no(), tint.getReg_id(), "2", "2");
			flag2 = d_db.updateDocSettle(doc.getDoc_no(), tint.getReg_id(), "3", "2");
			flag2 = d_db.updateDocSettle(doc.getDoc_no(), tint.getReg_id(), "4", "2");
			tint.setSup_dt		(tint.getSup_est_dt());
			tint.setReq_dt		(AddUtil.getDate());
			tint.setConf_dt		(AddUtil.getDate());
			if(tint.getTint_amt()==0){
				tint.setTint_amt	(181818*tint.getTint_su());//90909->181818 20190415
				tint.setR_tint_amt(tint.getTint_amt());
			}	
			//=====[tint] update=====
			flag1 = t_db.updateCarTint(tint);
		}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('용품 수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>