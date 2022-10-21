<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*,tax.*, acar.user_mng.*,acar.cont.*, acar.client.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	
	String mng_id[] = request.getParameterValues("mng_id");//담당자
	String l_cd[] = request.getParameterValues("l_cd"); //계약번호
	String c_id[] = request.getParameterValues("c_id");
	String m_id[] = request.getParameterValues("m_id");
	String car_no[] = request.getParameterValues("car_no");	
	String sms_yn = request.getParameter("sms_yn")==null?"":request.getParameter("sms_yn");
	
	String m1_chk = request.getParameter("m1_chk")==null?"":request.getParameter("m1_chk");
	String m1_content = request.getParameter("m1_content")==null?"":request.getParameter("m1_content");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	boolean flag1 = true;
	
	String m1_no= "";
	
	int count = 1;
	
	int result = 0;
	
		
	String off_nm = "성수자동차";
	String off_id = "007410"; //성수자동차 setting  005591 -> 007410,  부산 - 에프앤티코리아(부산) 008411
	
	if ( m1_chk.equals("5")) {	
		off_id = "008411";      //일등전국탁송
		off_nm = "에프앤티코리아";
	} 
	
	if ( m1_chk.equals("6")) {	// 부산검사(20160224)
		off_id = "009620";      //미스터박대리-> 차비서
		off_nm = "미스터박대리";
	} 
	
	if ( m1_chk.equals("8")) {	// 부산검사(20160224)
		off_id = "011614";      //미스터박대리-> 차비서
		off_nm = "차비서";
	} 
		
	if ( m1_chk.equals("A")) {	// 대구검사(202008224)
		off_id = "008462";      //미스터박대리
		off_nm = "성서현대";
	} 
	
	//1. 자동차검사 등록----------------------------------------------------------------------------------------	
		for(int i=0; i<c_id.length;i++) {
			
			count = rs_db.updateCarReqMaster1(c_id[i], m1_chk);
			
			CarMaintReqBean cons = new CarMaintReqBean();
			
			cons.setMng_id			(mng_id[i]);
			cons.setCar_mng_id		(c_id[i]);
			cons.setRent_l_cd		(l_cd[i]);
			cons.setM1_chk			(m1_chk);
			cons.setM1_content		(m1_content);
			cons.setOff_id			(off_id);
			cons.setOff_nm			(off_nm);
			cons.setGubun			(gubun);	
			
			System.out.println("검사의뢰 c_id :" +c_id[i]);
			m1_no = rs_db.insertCarMaintReq(cons);
			
			if(m1_no.equals("")){
				result++;
			}
					
			
			//안내문자 차량이용자에게 문자발송 20170125제안추가
			String reg_id = ck_acar_id;
			
					
			//로그인
			UsersBean user_bean2 = umd.getUsersBean(reg_id);
			
						
			String msg_subject="차량 검사 안내 문자";
				
					
			//계약기본정보
			ContBaseBean base = a_db.getCont(m_id[i], l_cd[i]);
			
			//고객정보
			ClientBean client = al_db.getNewClient(base.getClient_id());
			
			//고객관련자
			Vector car_mgrs = a_db.getCarMgrListNew(m_id[i], l_cd[i], "Y");
			int mgr_size = car_mgrs.size();
			
			//관리담당자
			UsersBean user_bean = umd.getUsersBean(base.getMng_id());
			
			if(base.getCar_st().equals("4")){
				user_bean = umd.getUsersBean(base.getMng_id2());
			}
			//외근직일 경우 본인이 발신자
			//if(!user_bean2.getLoan_st().equals("")){
			//	user_bean = user_bean2;
			//}
			
			String sendphone= user_bean.getUser_m_tel();
			String sendname=user_bean.getUser_nm();
			String destphone="";
			
			
			String firm_nm= client.getFirm_nm();
			
			
			for(int j = 0 ;j < mgr_size ;j++){
		    	CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(j);
		       if(mgr.getMgr_st().equals("차량이용자")){
					destphone = mgr.getMgr_m_tel()+"";
		       }
		   }
			
			if(sms_yn.equals("Y")){
					
					if(!destphone.equals("") && AddUtil.lengthb(destphone) > 9){
						String sms_content =firm_nm+"고객님 안녕하십니까. 친절과 신뢰로 모시는 아마존카입니다.\n\n고객님이 이용중인 자동차("+car_no[i]+")검사 실시를 위해  당사 협력업체에서 고객님에게 연락드릴 예정입니다.\n고객님의 안전한 차량운행을 위해 협조 부탁드립니다. 감사합니다.\n\n";
						sms_content= sms_content+"(주)아마존카 www.amazoncar.co.kr";
						int i_msglen = AddUtil.lengthb(sms_content);
						String msg_type = "5";
						String rqdate = "";
						
						//알림톡 테스트
				//		destphone = "01023542348";
				
						//알림톡 acar0051 차량 검사 안내 문자
						String customer_name 	= firm_nm;				// 고객이름
						String car_num 				= car_no[i];			// 차량번호
						
						String etc1 =  l_cd[i];
						String etc2 = reg_id ;
				
						//acar0051 -> acar0070 -> acar0208 문구수정
						List<String> fieldList = Arrays.asList(customer_name, car_num, sendname, sendphone);
						at_db.sendMessageReserve("acar0208", fieldList, destphone, sendphone, null,  etc1, etc2 );
					}	
			}
						
		//	System.out.println("result :" +result);
		}		
		
		
		
		
	
%>
<script language='javascript'>
<%	if(result  == 0){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
