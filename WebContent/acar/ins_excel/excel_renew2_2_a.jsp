<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*, acar.bill_mng.*, acar.user_mng.*,  acar.im_email.*, tax.*, acar.cont.*, acar.client.*"%>
<%@ page import="acar.kakao.*" %>

<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	//영업용 엑셀 등록후 미스발생분 : 보험가입등록분 생성후 에러로 스케줄, 전표생성인 안된것 처리	
	
	int flag = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	
	String ins_start_dt 	= request.getParameter("ins_start_dt")==null?"":AddUtil.replace(request.getParameter("ins_start_dt"),"-","");	//공통-보험시작일
	String ins_est_dt 	= request.getParameter("ins_est_dt")==null?"":AddUtil.replace(request.getParameter("ins_est_dt"),"-","");	//공통-보험시작일
	
	Vector inss = ai_db.getInsRegExcelErrorList(ins_start_dt, "1");
	int ins_size = inss.size();
	

	out.println("ins_start_dt="+ins_start_dt);
	out.println("ins_est_dt="+ins_est_dt);
			
			
	for (int i = 0 ; i < ins_size ; i++){
 		Hashtable ht = (Hashtable)inss.elementAt(i);		
	
	
		//보험정보
		InsurBean ins = ai_db.getInsCase(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("INS_ST")));


		out.println("car_mng_id="+ins.getCar_mng_id());
		out.println("ins_st="+ins.getCar_mng_id());
	
	
		//전보험 만료처리-----------------------------------------------
		if(!ai_db.changeInsSts(ins.getCar_mng_id(), AddUtil.parseInt(ins.getIns_st())-1, "2"))	flag += 1;
		
		out.println("전보험 만료처리");
					
						
						//보험갱신 스케줄 등록------------------------------------------
						
						//1회차
						InsurScdBean scd = new InsurScdBean();
						scd.setCar_mng_id	(ins.getCar_mng_id());
						scd.setIns_st		(ins.getIns_st());
						scd.setIns_tm		("1");																														
						scd.setIns_est_dt	(ins_est_dt);
						scd.setR_ins_est_dt	(ai_db.getValidDt(scd.getIns_est_dt()));//공휴일/주말일 경우 전날로 처리												
						scd.setPay_amt		(AddUtil.parseInt(String.valueOf(ht.get("TOT_AMT"))));
						scd.setPay_dt		("");
						scd.setPay_yn		("0");
						scd.setIns_tm2		("0");
						
						if(!ai_db.insertInsScd(scd)) flag += 1;
						
		out.println("보험갱신 스케줄 등록");	
		
		
					//자동전표처리한것이 없다면 다시 생성
					Vector fi_vt = neoe_db.getFI_ADOCU_LIST(ins.getIns_rent_dt(), "ins_add", String.valueOf(ht.get("CAR_NO")));
					int fi_size = fi_vt.size();		
		
					if(fi_size==0){
		
							
						//자동전표처리용
						Vector vt = new Vector();
						int line = 0;
						int count =0;
						String acct_cont = "";
						String acct_code = "";
			
						UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
						Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
						String insert_id = String.valueOf(per.get("SA_CODE"));
						String dept_code = String.valueOf(per.get("DEPT_CODE"));
	
						
						//보험사
						Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
			
						//대여차량선급보험료
						if(ins.getCar_use().equals("1")){
							acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " 영업용";
							acct_code = "13300";
						//리스차량선급보험료
						}else{
							acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " 업무용";
							acct_code = "13200";
						}
			
						if(ins.getIns_st().equals("0")) 			acct_cont = acct_cont+ " 신규 가입 ("+String.valueOf(ht.get("CAR_NO"))+")";
						else  							acct_cont = acct_cont+ " 갱신 가입 ("+String.valueOf(ht.get("CAR_NO"))+")";
			
						line++;
			
						//선급보험료
						Hashtable ht1 = new Hashtable();
						ht1.put("DATA_GUBUN", 	"53");
						ht1.put("WRITE_DATE", 	ins.getIns_rent_dt());
						ht1.put("DATA_NO",    	"");
						ht1.put("DATA_LINE",  	String.valueOf(line));
						ht1.put("DATA_SLIP",  	"1");
						ht1.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
						ht1.put("NODE_CODE",  	"S101");
						ht1.put("C_CODE",     	"1000");
						ht1.put("DATA_CODE",  	"");
						ht1.put("DOCU_STAT",  	"0");
						ht1.put("DOCU_TYPE",  	"11");
						ht1.put("DOCU_GUBUN", 	"3");
						ht1.put("AMT_GUBUN",  	"3");//차변
						ht1.put("DR_AMT",    	scd.getPay_amt());
						ht1.put("CR_AMT",     	"0");
						ht1.put("ACCT_CODE",  	acct_code);
						ht1.put("CHECK_CODE1",	"A19");//전표번호
						ht1.put("CHECK_CODE2",	"A07");//거래처
						ht1.put("CHECK_CODE3",	"A05");//표준적요
						ht1.put("CHECK_CODE4",	"");
						ht1.put("CHECK_CODE5",	"");
						ht1.put("CHECK_CODE6",	"");
						ht1.put("CHECK_CODE7",	"");
						ht1.put("CHECK_CODE8",	"");
						ht1.put("CHECK_CODE9",	"");
						ht1.put("CHECK_CODE10",	"");
						ht1.put("CHECKD_CODE1",	"");//전표번호
						ht1.put("CHECKD_CODE2",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
						ht1.put("CHECKD_CODE3",	"");//표준적요
						ht1.put("CHECKD_CODE4",	"");
						ht1.put("CHECKD_CODE5",	"");
						ht1.put("CHECKD_CODE6",	"");
						ht1.put("CHECKD_CODE7",	"");
						ht1.put("CHECKD_CODE8",	"");
						ht1.put("CHECKD_CODE9",	"");
						ht1.put("CHECKD_CODE10","");
						ht1.put("CHECKD_NAME1",	"");//전표번호
						ht1.put("CHECKD_NAME2",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
						ht1.put("CHECKD_NAME3",	acct_cont);//표준적요
						ht1.put("CHECKD_NAME4",	"");
						ht1.put("CHECKD_NAME5",	"");
						ht1.put("CHECKD_NAME6",	"");
						ht1.put("CHECKD_NAME7",	"");
						ht1.put("CHECKD_NAME8",	"");
						ht1.put("CHECKD_NAME9",	"");
						ht1.put("CHECKD_NAME10","");
						ht1.put("INSERT_ID",	insert_id);
			
						line++;
			
						//미지급금
						Hashtable ht2 = new Hashtable();
						ht2.put("DATA_GUBUN", 	"53");
						ht2.put("WRITE_DATE", 	ins.getIns_rent_dt());
						ht2.put("DATA_NO",    	"");
						ht2.put("DATA_LINE",  	String.valueOf(line));
						ht2.put("DATA_SLIP",  	"1");
						ht2.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
						ht2.put("NODE_CODE",  	"S101");
						ht2.put("C_CODE",     	"1000");
						ht2.put("DATA_CODE",  	"");
						ht2.put("DOCU_STAT",  	"0");
						ht2.put("DOCU_TYPE",  	"11");
						ht2.put("DOCU_GUBUN", 	"3");
						ht2.put("AMT_GUBUN",  	"4");//대변
						ht2.put("DR_AMT",    	"0");
						ht2.put("CR_AMT",     	scd.getPay_amt());
						ht2.put("ACCT_CODE",  	"25300");
						ht2.put("CHECK_CODE1",	"A07");//거래처
						ht2.put("CHECK_CODE2",	"A19");//전표번호
						ht2.put("CHECK_CODE3",	"F47");//신용카드번호
						ht2.put("CHECK_CODE4",	"A13");//project
						ht2.put("CHECK_CODE5",	"A05");//표준적요
						ht2.put("CHECK_CODE6",	"");
						ht2.put("CHECK_CODE7",	"");
						ht2.put("CHECK_CODE8",	"");
						ht2.put("CHECK_CODE9",	"");
						ht2.put("CHECK_CODE10",	"");
						ht2.put("CHECKD_CODE1",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
						ht2.put("CHECKD_CODE2",	"");//전표번호
						ht2.put("CHECKD_CODE3",	"");//신용카드번호
						ht2.put("CHECKD_CODE4",	"");//project
						ht2.put("CHECKD_CODE5",	"0");//표준적요
						ht2.put("CHECKD_CODE6",	"");
						ht2.put("CHECKD_CODE7",	"");
						ht2.put("CHECKD_CODE8",	"");
						ht2.put("CHECKD_CODE9",	"");
						ht2.put("CHECKD_CODE10","");
						ht2.put("CHECKD_NAME1",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
						ht2.put("CHECKD_NAME2",	"");//전표번호
						ht2.put("CHECKD_NAME3",	"");//신용카드번호
						ht2.put("CHECKD_NAME4",	"");//project
						ht2.put("CHECKD_NAME5",	acct_cont);//표준적요
						ht2.put("CHECKD_NAME6",	"");
						ht2.put("CHECKD_NAME7",	"");
						ht2.put("CHECKD_NAME8",	"");
						ht2.put("CHECKD_NAME9",	"");
						ht2.put("CHECKD_NAME10","");
						ht2.put("INSERT_ID",	insert_id);
			
						vt.add(ht1);
						vt.add(ht2);
			
						if(line > 0 && vt.size() > 0){

				
							String row_id = neoe_db.insertDebtSettleAutoDocu(ins.getIns_start_dt(), vt);	//-> neoe_db 변환
				
							if(row_id.equals("")){
								count = 1;
							}
						}
						
		out.println("자동전표처리용");												
						
						//20140618 모든 갱신등록 메일 및 문자 발송
						
						//cont_view
						Hashtable cont = a_db.getContViewUseYCarCase(ins.getCar_mng_id());
						String rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
						String rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
						
						String car_num = String.valueOf(cont.get("CAR_NO"));
						String car_name = String.valueOf(cont.get("CAR_NM"));
																
						//거래처
						ClientBean client = al_db.getClient(String.valueOf(cont.get("CLIENT_ID")));
				
						String subject 		= client.getFirm_nm()+"님, 자동차보험 갱신 안내메일입니다.";
																
						int seqidx		= 0;
		
				
						if(!client.getCon_agnt_email().equals("")){
							//	1. d-mail 등록-------------------------------
							DmailBean d_bean = new DmailBean();
							d_bean.setSubject			(subject);
							d_bean.setSql				("SSV:"+client.getCon_agnt_email().trim());
							d_bean.setReject_slist_idx	(0);
							d_bean.setBlock_group_idx	(0);
							d_bean.setMailfrom			("\"아마존카\"<34000233@amazoncar.co.kr>");
							d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+client.getCon_agnt_email().trim()+">");
							d_bean.setReplyto			("\"아마존카\"<34000233@amazoncar.co.kr>");
							d_bean.setErrosto			("\"아마존카\"<34000233@amazoncar.co.kr>");
							d_bean.setHtml				(1);
							d_bean.setEncoding			(0);
							d_bean.setCharset			("euc-kr");
							d_bean.setDuration_set		(1);
							d_bean.setClick_set			(0);
							d_bean.setSite_set			(0);
							d_bean.setAtc_set			(0);
							d_bean.setGubun				("insur");
							d_bean.setRname				("mail");
							d_bean.setMtype       		(0);
							d_bean.setU_idx       		(1);//admin계정
							d_bean.setG_idx				(1);//admin계정
							d_bean.setMsgflag     		(0);													
							d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ins/ins_gs_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&ins_start_dt="+ins.getIns_start_dt());
							d_bean.setV_content			("http://fms1.amazoncar.co.kr/mailing/ins/ins_gs_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&ins_start_dt="+ins.getIns_start_dt());
				
							seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", "+7");					
						}
							
						String ins_name = String.valueOf(ins_com.get("INS_COM_NM"));
						String ins_tel 	= "";
						if ( ins_name.equals("삼성화재") ) {
		    					ins_tel = "1588-5114 ";
						} else if  ( ins_name.equals("동부화재") || ins_name.equals("DB손해보험")) {
		    					ins_tel = "1588-0100";
						} else if  ( ins_name.equals("렌터카공제조합") ) {
								ins_tel = "1661-7977 ";			
						}
						
						if(!String.valueOf(cont.get("BUS_ID2")).equals("")){
							user_bean 	= umd.getUsersBean(String.valueOf(cont.get("BUS_ID2")));
						}
		
						String etc1 = rent_l_cd;
						String etc2 = ck_acar_id;
						
						String sendname 	= "(주)아마존카 "+user_bean.getUser_nm();
						String sendphone 	= user_bean.getUser_m_tel();
						
						
						String msg 		= client.getFirm_nm()+"고객님 안녕하십니까, 아마존카입니다. 고객님의 대여자동차 보험회사가 다음과 같이 갱신되었사오니 이용에 참고 부탁드립니다. 변경후 보험사 : "+ ins_name + " ("+ ins_tel +"), 긴급출동 및 견인 : 마스타긴급출동 1588-6688   (주)아마존카 www.amazoncar.co.kr ";
						
						//계약 담당자 변경 관련 문자
						Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
			
						String destphone 	= String.valueOf(sms.get("TEL"));			
						String destname 	= String.valueOf(sms.get("NM"));
						String customer_name =client.getFirm_nm();										// 고객 이름
						String sos_service_info = "마스타자동차 (1588-6688)";								// 긴급출동
						
						String marster_car_num = "1588-6688"; //마스터 자동차 연락처
						String sk_net_num = "1670-5494"; //sk네트웍스 연락처
						
						String url_1 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
						String sos_url = ShortenUrlGoogle.getShortenUrl(url_1);
						
						Date today = new Date();
						SimpleDateFormat format = new SimpleDateFormat("yyyy년 MM월 dd일");
						String update_date = String.valueOf(format.format(today));
						
						if(!destphone.equals("")){
							//보험사와 긴급출동 문자메세지 
							
              				/* List<String> fieldList = Arrays.asList(customer_name, ins_name, ins_tel, sos_service_info);
							at_db.sendMessageReserve("acar0112", fieldList, destphone,  sendphone, null , etc1,  etc2); */
							
             				//acar0045-> acar0059 (차량번호 추가) -> acar0091 (문구수정) -> acar00112 (애니카종료) -> acar0157 (sk네트웍스 추가) -> acar0232	 -> acar0259						
              				List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, ins_name, ins_tel, update_date, AddUtil.ChangeDate2(ins.getIns_start_dt()), AddUtil.ChangeDate2(ins.getIns_exp_dt()), marster_car_num, sk_net_num, sos_url);
							at_db.sendMessageReserve("acar0259", fieldList, destphone,  sendphone, null , etc1,  etc2);
						}
						
					}	
				
			
		out.println("<br>");																									

	}
	int ment_cnt=0;
	
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 보험 등록하기
</p>

<SCRIPT LANGUAGE="JavaScript">
<!--		

//-->
</SCRIPT>
</BODY>
</HTML>