<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, javax.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.off_anc.*, acar.coolmsg.*, acar.user_mng.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="f_bean" class="acar.off_anc.Bbs_FBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp"%>

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int bbs_id 		= request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String title 	= request.getParameter("title")==null?"":request.getParameter("title");
	String content 	= request.getParameter("content")==null?"":request.getParameter("content");
	String exp_dt 	= request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String read_yn 	= request.getParameter("read_yn")==null?"":request.getParameter("read_yn");
	String bbs_st 	= request.getParameter("bbs_st")==null?"":request.getParameter("bbs_st");
	
	
	String user_nm 	= "";
	String br_id 	= "";
	String br_nm 	= "";
	String dept_id 	= "";
	String dept_nm 	= "";
	String p_view 	= request.getParameter("p_view")==null?"":request.getParameter("p_view");
	String scm_yn 	= request.getParameter("scm_yn")==null?"":request.getParameter("scm_yn");
	
	String title1 		= request.getParameter("title1")==null?"":request.getParameter("title1");
	String content1 	= request.getParameter("content1")==null?"":request.getParameter("content1");
	String content2 	= request.getParameter("content2")==null?"":request.getParameter("content2");
	String d_user_id 	= "";
	String d_user_id1 	= request.getParameter("d_user_id1")==null?"":request.getParameter("d_user_id1");
	String d_user_id2 	= request.getParameter("d_user_id2")==null?"":request.getParameter("d_user_id2");
	String d_day_st 	= "";
	String d_day_st1 	= request.getParameter("d_day_st1")==null?"":request.getParameter("d_day_st1");
	String d_day_st2 	= request.getParameter("d_day_st2")==null?"":request.getParameter("d_day_st2");
	String d_day_ed 	= request.getParameter("d_day_ed")==null?"":request.getParameter("d_day_ed");
	String place_nm 	= "";
	String place_tel 	= "";
	String place_addr 	= "";
	String place_nm1 	= request.getParameter("place_nm1")==null?"":request.getParameter("place_nm1");
	String place_tel1 	= request.getParameter("place_tel1")==null?"":request.getParameter("place_tel1");
	String place_addr1 	= request.getParameter("place_addr1")==null?"":request.getParameter("place_addr1");
	String place_nm2 	= request.getParameter("place_nm2")==null?"":request.getParameter("place_nm2");
	String place_tel2 	= request.getParameter("place_tel2")==null?"":request.getParameter("place_tel2");
	String place_addr2 	= request.getParameter("place_addr2")==null?"":request.getParameter("place_addr2");
	String chief_nm 	= request.getParameter("chief_nm")==null?"":request.getParameter("chief_nm");
	String d_day_place 	= request.getParameter("d_day_place")==null?"":request.getParameter("d_day_place");
	String family_relations = request.getParameter("family_relations")==null?"":request.getParameter("family_relations");
	String deceased_nm 	= request.getParameter("deceased_nm")==null?"":request.getParameter("deceased_nm");
	String deceased_day = request.getParameter("deceased_day")==null?"":request.getParameter("deceased_day");
	String title_st 	= request.getParameter("title_st")==null?"":request.getParameter("title_st");
	String comst 		= request.getParameter("comst")==null?"":request.getParameter("comst");
	String impor_yn 	= request.getParameter("impor_yn")==null?"":request.getParameter("impor_yn");
	
	String keywords 	= request.getParameter("keywords")==null?"":request.getParameter("keywords");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String end_st 		= request.getParameter("end_st")==null?"":request.getParameter("end_st");
	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	int count = 0;
	int count1 = 0;
	int i = 4;
	int result = 0;	
	boolean flag = false;
	
	if(bbs_st.equals("5")){
		title = title1;
		if(title_st.equals("1")||title_st.equals("3")){	
			content = request.getParameter("content1")==null?"":request.getParameter("content1");
			if(exp_dt.equals(""))  	exp_dt = d_day_ed;		//결혼/돌에는 행사종료일시
			place_nm = place_nm1;
			place_tel = place_tel1;
			place_addr = place_addr1;
			d_user_id = d_user_id1;
			d_day_st = d_day_st1;
		}else{
			content = request.getParameter("content2")==null?"":request.getParameter("content2");
			if(exp_dt.equals(""))		exp_dt = d_day_st2;		//부고시 발인일을 입력.
			place_nm = place_nm2;
			place_tel = place_tel2;
			place_addr = place_addr2;
			d_user_id = d_user_id2;
			d_day_st = d_day_st2;
		}
	}
	
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	
	a_bean.setBbs_id(bbs_id);
	a_bean.setUser_id(user_id);
	if(cmd.equals("u")){
		if(!exp_dt.equals("")) 		a_bean.setExp_dt(exp_dt);
		if(!title.equals("")) 		a_bean.setTitle(title);
		if(!content.equals(""))		a_bean.setContent(content);
		if(!read_yn.equals(""))		a_bean.setRead_yn(read_yn);
		if(!bbs_st.equals(""))		a_bean.setBbs_st(bbs_st);
		if(!p_view.equals(""))		a_bean.setP_view(p_view);
		if(!scm_yn.equals(""))		a_bean.setScm_yn(scm_yn);
		if(!impor_yn.equals(""))	a_bean.setImpor_yn(impor_yn);
	}else{
		a_bean.setExp_dt(exp_dt);
		a_bean.setTitle(title);
		a_bean.setContent(content);
		a_bean.setRead_yn(read_yn);
		a_bean.setBbs_st(bbs_st);
		a_bean.setP_view(p_view);
		a_bean.setScm_yn(scm_yn);
		a_bean.setImpor_yn(impor_yn);
	}
	a_bean.setKeywords(keywords);
	a_bean.setCar_comp_id(car_comp_id);
	a_bean.setCar_cd(code);
	a_bean.setEnd_st(end_st);
	
	
	if (bbs_st.equals("6")) {
		if(user_id.equals("000003") || user_id.equals("000004") || user_id.equals("000005")){ 
			a_bean.setComst("Y");
		}	
    }

	
	if (cmd.equals("d")|| cmd.equals("u")) {
		if(cmd.equals("u")){
			if(title_st.equals("1")){
				content = content1;
			}else if(title_st.equals("2")){
				content = content2;
			}
			if(content.equals("") || content == null){
%>
			<script>
				alert("내용을 입력하십시오");
			</script>
<%				
			}else{
				count = oad.updateAncNew(a_bean);
				
			}
			if(bbs_st.equals("5")){
		
				if(title_st.equals("1")||title_st.equals("3")){
					
					f_bean.setBbs_id(bbs_id);
					f_bean.setReg_id(user_id);
					f_bean.setD_user_id(d_user_id);
					f_bean.setTitle(title);
					f_bean.setD_day_st(d_day_st);
					f_bean.setD_day_ed(d_day_ed);
					f_bean.setPlace_nm(place_nm);
					f_bean.setPlace_tel(place_tel);
					f_bean.setPlace_addr(place_addr);
					f_bean.setTitle_st(title_st);

					
					count1 = oad.updateAnc_Family1(f_bean);
					
				}else{
					
					f_bean.setBbs_id(bbs_id);
					f_bean.setReg_id(user_id);
					f_bean.setD_user_id(d_user_id);
					f_bean.setTitle(title);
					f_bean.setDeceased_nm(deceased_nm);
					f_bean.setDeceased_day(deceased_day);
					f_bean.setFamily_relations(family_relations);
					f_bean.setD_day_st(d_day_st);
					f_bean.setD_day_place(d_day_place);
					f_bean.setChief_nm(chief_nm);
					f_bean.setPlace_nm(place_nm);
					f_bean.setPlace_tel(place_tel);
					f_bean.setPlace_addr(place_addr);
					f_bean.setTitle_st(title_st);
					
					count1 = oad.updateAnc_Family2(f_bean);
				}
			
			}
		
		}else if(cmd.equals("d")){
			
				count = oad.deleteAnc(a_bean);		
						
		}
	}
	else if(cmd.equals("i")){
	
		if(content.equals("") || content == null){
%>
			<script>
				alert("내용을 입력하십시오");
			</script>
<%				
		}else{	
						
			count = oad.insertAncNew(a_bean);	//<--주석처리 
		//	count = oad.insertAnc(a_bean);
						
		}
			
		if(bbs_st.equals("5")){
		
			bbs_id = AddUtil.parseInt(oad.getBbs_id(user_id, title));
			
			//경조사 등록시 쿨메신저 및 알림톡 보내기(2018.01.15) 
			String sub 		= "";
			String cont 	= "";
			String target_id1 = "000004";	//총무팀장님
			String target_id2 = "000128";	//총무팀 박휘영 대리님
			
			//사용자 정보 조회
			UserMngDatabase umd = UserMngDatabase.getInstance();
			UsersBean target_bean1 	= umd.getUsersBean(target_id1);
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			UsersBean d_user_bean 	= umd.getUsersBean(d_user_id);
			
			if(title_st.equals("1")||title_st.equals("3")){		// 결혼, 돌

				f_bean.setBbs_id(bbs_id);
				f_bean.setReg_id(user_id);
				f_bean.setD_user_id(d_user_id);
				f_bean.setTitle(title);
				f_bean.setD_day_st(d_day_st);
				f_bean.setD_day_ed(d_day_ed);
				f_bean.setPlace_nm(place_nm);
				f_bean.setPlace_tel(place_tel);
				f_bean.setPlace_addr(place_addr);
				f_bean.setTitle_st(title_st);
				
				count = oad.insertAnc_Family1(f_bean);
				
			}else{		//	부고
				f_bean.setBbs_id(bbs_id);
				f_bean.setReg_id(user_id);
				f_bean.setD_user_id(d_user_id);
				f_bean.setTitle(title);
				f_bean.setDeceased_nm(deceased_nm);
				f_bean.setDeceased_day(deceased_day);
				f_bean.setFamily_relations(family_relations);
				f_bean.setD_day_st(d_day_st);
				f_bean.setD_day_place(d_day_place);
				f_bean.setChief_nm(chief_nm);
				f_bean.setPlace_nm(place_nm);
				f_bean.setPlace_tel(place_tel);
				f_bean.setPlace_addr(place_addr);
				f_bean.setTitle_st(title_st);
				
				count = oad.insertAnc_Family2(f_bean);
			}
			
			if(count==1){	//쿨메신저 보내기
				sub = f_bean.getTitle();
				cont = f_bean.getTitle() + "\n\n";
				if(title_st.equals("1")||title_st.equals("3")){		cont += "일시 : ";	}
				else if(title_st.equals("2")){						cont += "발인 : ";	}
				cont += f_bean.getD_day_st() + "\n\n장소 : " + f_bean.getPlace_nm() + " (" + f_bean.getPlace_tel() + ")";
				
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
		  					"    <BACKIMG>4</BACKIMG>"+
		  					"    <MSGTYPE>104</MSGTYPE>"+
		  					"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
		 					"    <URL></URL>";
				xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		  					"    <MSGICON>10</MSGICON>"+
		  					"    <MSGSAVE>1</MSGSAVE>"+
		  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
		  					"  </ALERTMSG>"+
		  					"</COOLMSG>"; 
				
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1"); 
					
				flag = cm_db.insertCoolMsg(msg);
			}
			if(title_st.equals("1")||title_st.equals("3")){		// 결혼, 돌(총무팀장님께 문자는 부고만)
			}else{
				if(count==1){
					//부고 등록시 알림톡 보내기(총무팀장님에게만)(2018.01.24)
					String d_user_nm 	= d_user_bean.getUser_nm();		// 당사자 성명
					String d_user_tel 	= d_user_bean.getUser_m_tel();	// 당사자연락처
					String at_cont      = "";
					at_cont += "[경조사 알림]\n\n삼가 고인의 명복을 빕니다\n\n" +
					           title+"\n\n" +
							   "당사자 : " + d_user_nm +"("+d_user_tel+")\n" +
					           "상주 : " + chief_nm + "\n" +
					           "고인 : " + deceased_nm + "\n" +
					           "발인 : " + d_day_st + "\n" +
							   "장례식장 : " + place_nm + " / " + place_tel + "\n" +
							   place_addr + "\n\n" +
							   "(주)아마존카 (www.amazoncar.co.kr)";
					
							   //메신저로만
							   //^^^VVV총무팀장님 요청으로 문자발송 다시 적용(2018.03.12)
					at_db.sendMessage(1009, "0", at_cont, target_bean1.getUser_m_tel(), sender_bean.getUser_m_tel(), null, "", user_id);		   
					
					// VVV 경조사 템플릿 -비즈톡 반려로 인해 직접입력(친구톡, 문자)로 대체(2018.02.05) ^^^
				//	List<String> fieldList = Arrays.asList(title, d_user_nm, d_user_tel, chief_nm, deceased_nm, d_day_st, place_nm, place_tel, place_addr);
				//	at_db.sendMessage("1009", "acar0121", fieldList, target_bean1.getUser_m_tel(),  sender_bean.getUser_m_tel(), null , "",  user_id) ;
					//at_db.sendMessageReserve("acar0121", fieldList, target_bean1.getUser_m_tel(), sender_bean.getUser_m_tel(), null , "",  user_id);
				}
			}
		}
	}else if(cmd.equals("exp_dt_u")){
		a_bean = oad.getAncBean(bbs_id);
		a_bean.setExp_dt(exp_dt);
		a_bean.setExp_dt_chg_yn("Y");
		count = oad.updateAncNew(a_bean);
	}
		
	
//out.print(count);
%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="POST">
	<input type='hidden' name='bbs_id' value='<%=bbs_id%>'>
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='bbs_st' value='<%=bbs_st%>'>
	<input type='hidden' name='comst' value='<%=comst%>'>
	<input type="hidden" name="cmd"	value=""> 

</form>

<script language="JavaScript">
<!--
	var fm = document.form1;

<%	if(cmd.equals("u")||cmd.equals("exp_dt_u")){
		if(count==1){		
%>
		alert("정상적으로 수정되었습니다.");
		fm.action='./anc_s_grid_frame.jsp';
		fm.target='d_content'; 
		top.window.close();
		fm.submit();		

<%		}else if(count==0){
%>
		return false;
<%				
		}
		
	}else if(cmd.equals("d")){
		if(count>0){		
%>
		alert("정상적으로 삭제되었습니다.");
		fm.action='./anc_s_grid_frame.jsp';
		fm.target='d_content';
		top.window.close();
		fm.submit();
<%		}
	}else if(cmd.equals("i")){
		if(bbs_st.equals("5")){
			if(count==1 && flag==true){	result = 1;	}
		}else{
			if(count==1)			  {	result = 1;	}
		}
	
		if(result==1){
%>
			alert("정상적으로 등록되었습니다.");
			fm.action='./anc_s_grid_frame.jsp';
			fm.target='d_content';
			top.window.close();
			fm.submit();					
<%
		}else{}
	}	
%>	
//-->
</script>
</body>
</html>
