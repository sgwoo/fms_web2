<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*, acar.bill_mng.*, acar.user_mng.*,  acar.im_email.*, tax.*, acar.cont.*, acar.client.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	String ins_rent_dt 	= request.getParameter("ins_rent_dt")==null?"":request.getParameter("ins_rent_dt");	//공통-보험가입일
	String ins_start_dt 	= request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");	//공통-보험시작일
	String ins_end_dt 	= request.getParameter("ins_end_dt")==null?"":request.getParameter("ins_end_dt");	//공통-보험만료일
	String t_pay_est_dt 	= request.getParameter("t_pay_est_dt")==null?"":request.getParameter("t_pay_est_dt");	//공통-보험납일일
	String ins_com_id 	= request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");	//공통-보험사코드
	
	
	String result[]  = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	//1 증권번호
	String value1[]  	= request.getParameterValues("value1");	//2 차량번호
	String value2[]  	= request.getParameterValues("value2");	//3 대인배상Ⅰ
	String value3[]  	= request.getParameterValues("value3");	//4 대인배상Ⅱ
	String value4[]  	= request.getParameterValues("value4");	//5 대물배상
	String value5[]  	= request.getParameterValues("value5");	//6 자기신체사고
	String value6[]  	= request.getParameterValues("value6");	//7 무보험차상해
	String value7[]  	= request.getParameterValues("value7");	//8 분담금할증한정
	String value8[]  	= request.getParameterValues("value8");	//9 자기차량손해
	String value9[]  	= request.getParameterValues("value9");	//10 애니카
	String value10[] 	= request.getParameterValues("value10");//11 총보험료
	String value11[] 	= request.getParameterValues("value11");//12 ⑫임직원전용자동차보험가입여부
	String value12[] 	= request.getParameterValues("value12");
	String value13[] 	= request.getParameterValues("value13");
	String value14[] 	= request.getParameterValues("value14");
	String value15[] 	= request.getParameterValues("value15");
	String value16[] 	= request.getParameterValues("value16");
	String value17[] 	= request.getParameterValues("value17");
	String value18[] 	= request.getParameterValues("value18");
	String value19[] 	= request.getParameterValues("value19");
			
	
	
	String ins_con_no 	= "";
	String car_no 		= "";
	int    ins_amt1 	= 0;
	int    ins_amt2 	= 0;
	int    ins_amt3 	= 0;
	int    ins_amt4 	= 0;
	int    ins_amt5 	= 0;
	int    ins_amt6 	= 0;
	int    ins_amt7 	= 0;
	int    ins_amt8 	= 0;
	int    tot_amt 		= 0;
	int    pay_tm 		= 1;
	int    f_amt 		= 0;
	String f_dt 		= "";
	int    t_amt 		= 0;
	String t_dt 		= "";
	String ins_est_dt	= "";
	String com_emp_yn	= "";
	int flag = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		
		ins_con_no 		= value0[i] ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value0[i],"_","")," ",""),"_ ","");
		car_no 			= value1[i] ==null?"":AddUtil.replace(value1[i]," ","");
		ins_amt1 		= value2[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value2[i],"_ ",""));
		ins_amt2 		= value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],"_ ",""));
		ins_amt3 		= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value4[i],"_ ",""));
		ins_amt4 		= value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"_ ",""));
		ins_amt5 		= value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value6[i],"_ ",""));
		ins_amt8 		= value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],"_ ",""));		
		ins_amt6 		= value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],"_ ",""));
		ins_amt7 		= value9[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value9[i],"_ ",""));
		tot_amt 		= value10[i]==null?0: AddUtil.parseDigit(AddUtil.replace(value10[i],"_ ",""));
		com_emp_yn		= value11[i] ==null?"":AddUtil.replace(value11[i]," ","");
		
		ins_amt1 		= value2[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value2[i],",",""));
		ins_amt2 		= value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],",",""));
		ins_amt3 		= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value4[i],",",""));
		ins_amt4 		= value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],",",""));
		ins_amt5 		= value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value6[i],",",""));
		ins_amt8 		= value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],",",""));
		ins_amt6 		= value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],",",""));
		ins_amt7 		= value9[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value9[i],",",""));
		tot_amt 		= value10[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value10[i],",",""));
	

		
		//중복입력 체크-----------------------------------------------------
		int over_cnt = ai_db.getCheckOverIns(car_no, ins_con_no);
		
		out.println("중복입력 체크="+over_cnt);
		
		
		if(!ins_con_no.equals("") && over_cnt == 0){
			//최근보험 조회-------------------------------------------------
			InsurBean ins = ai_db.getInsExcelCase(car_no);
			
			InsurBean old_ins = ins;
			
			out.println("car_no="+car_no);
			out.println("ins_con_no="+ins_con_no);
			out.println("ins.getIns_start_dt()="+ins.getIns_start_dt());
			out.println("AddUtil.getDate(1)="+AddUtil.getDate(1));
			out.println("<br>");
		
			

			if(!ins.getCar_mng_id().equals("") && ins.getIns_start_dt().length()>4 && ins.getIns_start_dt().substring(0,4).equals(AddUtil.getDate(1))){
			
				//보험갱신 등록-------------------------------------------------
				int ins_st = AddUtil.parseInt(ins.getIns_st())+1;
				ins.setIns_st			(Integer.toString(ins_st));
				ins.setIns_sts			("1");//1:유효, 2:만료, 3:중도해지, 4:오프리스보험
				ins.setIns_con_no		(ins_con_no);
				ins.setRins_pcp_amt		(ins_amt1);//대인배상1
				ins.setVins_pcp_amt		(ins_amt2);//대인배상2
				ins.setVins_gcp_amt		(ins_amt3);//대물배상
				ins.setVins_bacdt_amt		(ins_amt4);//자기신체사고
				ins.setVins_canoisr_amt		(ins_amt5);//무보험차상해
				ins.setVins_share_extra_amt	(ins_amt8);//분담금할증한정
				ins.setVins_cacdt_cm_amt	(ins_amt6);//자기차량손해
				ins.setVins_spe_amt		(ins_amt7);//애니카
				ins.setVins_spe			("");//20090210부터 긴급출동 미가입
				ins.setPay_tm			(Integer.toString(pay_tm));
				ins.setReg_cau			("4");//4:만기
				ins.setIns_com_id		(ins_com_id);
				ins.setIns_rent_dt		(ins.getIns_start_dt());			
				ins.setCom_emp_yn		(com_emp_yn);			
				
				if(!ai_db.insertIns(ins))	flag += 1;
				else{
					
					//전보험 만료처리-----------------------------------------------
					if(!ai_db.changeInsSts(ins.getCar_mng_id(), ins_st-1, "2"))	flag += 1;
					else{
						
						//보험갱신 스케줄 등록------------------------------------------
						
						//1회차
						InsurScdBean scd = new InsurScdBean();
						scd.setCar_mng_id	(ins.getCar_mng_id());
						scd.setIns_st		(Integer.toString(ins_st));
						scd.setIns_tm		("1");
						
						
						
						ins_est_dt = t_pay_est_dt;
						
						scd.setIns_est_dt	(ins_est_dt);
						scd.setR_ins_est_dt	(ai_db.getValidDt(scd.getIns_est_dt()));//공휴일/주말일 경우 전날로 처리
						
						
						scd.setPay_amt		(tot_amt);						
						scd.setPay_dt		("");
						scd.setPay_yn		("0");
						scd.setIns_tm2		("0");
						
						if(!ai_db.insertInsScd(scd)) flag += 1;
						
						
						UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
						//보험사
						Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
						
						
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
		    					ins_tel = "1588-5114, ";
						} else if  ( ins_name.equals("동부화재") || ins_name.equals("DB손해보험")) {
		    					ins_tel = "1588-0100,";
		    			} else if  ( ins_name.equals("렌터카공제조합") ) {
								ins_tel = "1661-7977, ";					
						}
						
						if(!String.valueOf(cont.get("BUS_ID2")).equals("")){
							user_bean 	= umd.getUsersBean(String.valueOf(cont.get("BUS_ID2")));
						}
						
						String etc1 = rent_l_cd;
						String etc2 = ck_acar_id;
	
						String sendname 	= "(주)아마존카 "+user_bean.getUser_nm();
						String sendphone 	= user_bean.getUser_m_tel();
						
						
						//String msg 		= "[자동차보험 갱신] 보험사는 "+ ins_name + " "+ ins_tel +" 긴급출동은 마스타자동차 1588-6688 입니다. (주)아마존카 ";
						String msg 		= client.getFirm_nm()+"고객님 안녕하십니까, 아마존카입니다. 고객님의 대여자동차 보험회사가 다음과 같이 갱신되었사오니 이용에 참고 부탁드립니다. 변경후 보험사 : "+ ins_name + " ("+ ins_tel +"), 긴급출동 및 견인 : 마스타긴급출동 1588-6688, SK네트웍스 1670-5494   (주)아마존카 www.amazoncar.co.kr ";
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
							
							//acar0045-> acar0059 (차량번호 추가) -> acar0091 (문구수정) -> acar00112 (애니카종료) -> acar0157 (sk네트웍스 추가) -> acar0232 -> acar0259
							List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, ins_name, ins_tel, update_date, AddUtil.ChangeDate2(ins.getIns_start_dt()), AddUtil.ChangeDate2(ins.getIns_exp_dt()), marster_car_num, sk_net_num, sos_url);
							at_db.sendMessageReserve("acar0259", fieldList, destphone,  sendphone, null , etc1,  etc2);
						}
						
					}
					if(flag != 0)	result[i] = "보험 등록중 오류 발생";
					else			result[i] = "보험 등록되었습니다.";
				}
			}else{
				result[i] = "갱신 대상이 아닙니다.";
			}
		}else{
		
		
			//이미 등록된 보험이다.. 스케줄생성 확인할것..
			if(!ins_con_no.equals("") && over_cnt > 0){
						
				//최근보험 조회-------------------------------------------------
				InsurBean ins = ai_db.getInsChkExcelCase(car_no);
				
				InsurScdBean scd = ai_db.getInsScd(ins.getCar_mng_id(), ins.getIns_st(), "1");
				
				if(scd.getCar_mng_id().equals("")){
				
					out.println("이미 등록된 보험이나 스케줄미생성분");
					out.println("car_no="+car_no);
					out.println("ins_con_no="+ins_con_no);
					out.println("ins.getIns_start_dt()="+ins.getIns_start_dt());
					out.println("AddUtil.getDate(1)="+AddUtil.getDate(1));
					out.println("<br>");
				
				
						//1회차				
						scd.setCar_mng_id	(ins.getCar_mng_id());
						scd.setIns_st		(ins.getIns_st());
						scd.setIns_tm		("1");
												
						ins_est_dt = t_pay_est_dt;
						
						scd.setIns_est_dt	(ins_est_dt);
						scd.setR_ins_est_dt	(ai_db.getValidDt(scd.getIns_est_dt()));//공휴일/주말일 경우 전날로 처리
						
						
						scd.setPay_amt		(tot_amt);						
						scd.setPay_dt		("");
						scd.setPay_yn		("0");
						scd.setIns_tm2		("0");
						
						if(!ai_db.insertInsScd(scd)) flag += 1;
						
						UsersBean user_bean 	= umd.getUsersBean("000056");
						
						//보험사
						Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
						
						
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
						
						
						//String msg 		= "[자동차보험 갱신] 보험사는 "+ ins_name + " "+ ins_tel +" 긴급출동은 마스타자동차 1588-6688 입니다. (주)아마존카 ";
						String msg 		= client.getFirm_nm()+"고객님 안녕하십니까, 아마존카입니다. 고객님의 대여자동차 보험회사가 다음과 같이 갱신되었사오니 이용에 참고 부탁드립니다. 변경후 보험사 : "+ ins_name + " ("+ ins_tel +"), 긴급출동 및 견인 : 마스타긴급출동 1588-6688   (주)아마존카 www.amazoncar.co.kr ";
						
						//계약 담당자 변경 관련 문자
						Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
			
						String destphone 	= String.valueOf(sms.get("TEL"));			
						String destname 	= String.valueOf(sms.get("NM"));
						String customer_name =client.getFirm_nm();		// 고객 이름
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
							
							//acar0045-> acar0059 (차량번호 추가) -> acar0091 (문구수정) -> acar00112 (애니카종료) -> acar0157 (sk네트웍스 추가) -> acar0232 -> acar0259
							List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, ins_name, ins_tel, update_date, AddUtil.ChangeDate2(ins.getIns_start_dt()), AddUtil.ChangeDate2(ins.getIns_exp_dt()), marster_car_num, sk_net_num, sos_url);
							at_db.sendMessageReserve("acar0259", fieldList, destphone,  sendphone, null , etc1,  etc2);
							
						}								
						
					result[i] = "이미 등록된 보험입니다. 스케줄미생성으로 추가처리 ";	
				}else{
					result[i] = "이미 등록된 보험입니다.";	
				}
				
			}
		
			//System.out.println(car_no+" 이미 등록된 보험입니다.");
			
		}
	}
	int ment_cnt=0;
	
	if(1==1)return;
	
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
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("보험 등록되었습니다.")) continue;
		ment_cnt++;%>
<input type='hidden' name='ins_con_no' value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='car_no'     value='<%=value1[i] ==null?"":value1[i]%>'>
<input type='hidden' name='result'     value='<%=result[i]%>'>
<%	}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>