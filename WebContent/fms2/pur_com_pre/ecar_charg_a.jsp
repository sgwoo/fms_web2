<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.car_office.*, acar.coolmsg.* "%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ec_bean" class="acar.car_office.EcarChargerBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 			= request.getParameter("auth_rw")			==null?"":request.getParameter("auth_rw");
	String user_id 			= request.getParameter("user_id")			==null?"":request.getParameter("user_id");
	String br_id 				= request.getParameter("br_id")				==null?"":request.getParameter("br_id");
	
	String mode				= request.getParameter("mode")				==null?"":request.getParameter("mode");
	String l_cd				= request.getParameter("rent_l_cd")		==null?"":request.getParameter("rent_l_cd");
	String m_id 				= request.getParameter("rent_mng_id")	==null?"":request.getParameter("rent_mng_id");
	String client_id 			= request.getParameter("client_id")			==null?"":request.getParameter("client_id");
	String c_id 				= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	String chg_type 		= request.getParameter("chg_type")		==null?"":request.getParameter("chg_type");
	String inst_off_r		= request.getParameter("inst_off_r")		==null?"":request.getParameter("inst_off_r");
	String inst_zip 			= request.getParameter("inst_zip")			==null?"":request.getParameter("inst_zip");
	String inst_loc 			= request.getParameter("inst_loc")			==null?"":request.getParameter("inst_loc");
	String pay_way 		= request.getParameter("pay_way")			==null?"":request.getParameter("pay_way");
	String chg_prop 		= request.getParameter("chg_prop")		==null?"":request.getParameter("chg_prop");
	String etc_inst_off 	= request.getParameter("etc_inst_off")		==null?"":request.getParameter("etc_inst_off");
	String param			 	= request.getParameter("param")			==null?"":request.getParameter("param");
	boolean flag 		= false;
	boolean chk 		= false;
	String error_msg 	= ""; 
	
	CarOffPreDatabase 		cop  = CarOffPreDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	ec_bean = cop.getEcarChargerOne(l_cd, m_id);
	
	if(ec_bean.getCar_mng_id().equals("")||mode.equals("U")){	 //기등록건이 없으면 & 수정건이면
		chk = true;			
		
		if(inst_off_r.equals("1")){		etc_inst_off = "파워큐브";					}
		if(inst_off_r.equals("2")){		etc_inst_off = "매니지온(이볼트)";		}
		if(inst_off_r.equals("11")){	etc_inst_off = "대영채비";					}
		
		ec_bean.setRent_l_cd			(l_cd);
		ec_bean.setRent_mng_id		(m_id);
		ec_bean.setClient_id				(client_id);
		ec_bean.setCar_mng_id		(c_id);
		ec_bean.setReg_id				(ck_acar_id);
		ec_bean.setChg_type			(chg_type);
		ec_bean.setInst_off				(inst_off_r);
		ec_bean.setInst_zip				(inst_zip);
		ec_bean.setInst_loc				(inst_loc);
		ec_bean.setPay_way				(pay_way);
		ec_bean.setChg_prop			(chg_prop);
		ec_bean.setUse_yn				("Y");
		ec_bean.setEtc_inst_off		(etc_inst_off );
	}
	
	if(mode.equals("I")){	//등록
		if(chk==true){
			flag = cop.insertRegEcarCharger(ec_bean);
			
			if(flag==true){	//등록시 함윤원 과장님에게 메세지
				String sub1 		= "전기차 충전기 신청 등록";
				String cont1 		= "[ "+ec_bean.getRent_l_cd()+" ] 전기차 충전기 신청이 등록 되었습니다.";
				String target_id1 	= "000144";	//함윤원 과장님
				//사용자 정보 조회
				UsersBean target_bean1 	= umd.getUsersBean(target_id1);

				String xml_data1 = "";
				xml_data1 =  "<COOLMSG>"+
									 "<ALERTMSG>"+
	  								 "    <BACKIMG>4</BACKIMG>"+
									 "    <MSGTYPE>104</MSGTYPE>"+
									 "    <SUB>"+sub1+"</SUB>"+
			  						 "    <CONT>"+cont1+"</CONT>"+
									 "    <URL></URL>";
				xml_data1 += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
				xml_data1 += "    <SENDER></SENDER>"+
	  								 "    <MSGICON>10</MSGICON>"+
									 "    <MSGSAVE>1</MSGSAVE>"+
	  								 "    <LEAVEDMSG>1</LEAVEDMSG>"+
									 "    <FLDTYPE>1</FLDTYPE>"+
	  								 "  </ALERTMSG>"+
									 "</COOLMSG>";
				CdAlertBean msg1 = new CdAlertBean();
				msg1.setFlddata(xml_data1);
				msg1.setFldtype("1");

				boolean flag_msg1 = cm_db.insertCoolMsg(msg1);
			}
		}else{
			flag = true;
			error_msg = l_cd + "는 이미 전기차 충전기 신청 내역이 있습니다.";
		}
	}else if(mode.equals("U")){
		flag = cop.updateEcarChargerBean(ec_bean); 
		
	}else if(mode.equals("U_ALL")){
		String [] param_arr = param.split("//");
	//	int cnt=0;	
		for(int i=0; i<param_arr.length;i++){
			
			String [] str = param_arr[i].split(",");
			ec_bean = cop.getEcarChargerOne(str[0], "");
			
			if(str[1].equals("N")){		str[1] = "";	}
			if(str[2].equals("N")){		str[2] = "";	}
			
			if(!ec_bean.getSubsi_form_yn().equals(String.valueOf(str[1]))||!ec_bean.getDoc_yn().equals(String.valueOf(str[2]))){
				flag = cop.updateEcarChargerDocYn(str[0], str[1], str[2]);
				
				if(flag==true){		
					//각 변경 건이 있으면 담당자(등록자)에게 메세지
					String doc_title = "";
					if(str[1].equals("Y")&&!ec_bean.getSubsi_form_yn().equals(String.valueOf(str[1]))){			doc_title += "보조금신청서";		}
					if((str[1].equals("Y")&&!ec_bean.getSubsi_form_yn().equals(String.valueOf(str[1]))) 
						&& (str[2].equals("Y")&&!ec_bean.getDoc_yn().equals(String.valueOf(str[2])))){			doc_title += ", ";					}
					if(str[2].equals("Y")&&!ec_bean.getDoc_yn().equals(String.valueOf(str[2]))){						doc_title += "완료서류"	;			}
					
					if((str[1].equals("Y")&&!ec_bean.getSubsi_form_yn().equals(String.valueOf(str[1]))) 
					 	|| (str[2].equals("Y")&&!ec_bean.getDoc_yn().equals(String.valueOf(str[2])))){
						
						String sub1 		= "전기차 충전기 "+ doc_title +" 처리완료";
						String cont1 		= "[ "+ec_bean.getRent_l_cd()+" ] 전기차 충전기 "+ doc_title +" 처리가 완료되었습니다.";
						String target_id1 	= ec_bean.getReg_id();	
						//사용자 정보 조회
						UsersBean target_bean1 	= umd.getUsersBean(target_id1);
		
						String xml_data1 = "";
						xml_data1 =  "<COOLMSG>"+
											 "<ALERTMSG>"+
			  								 "    <BACKIMG>4</BACKIMG>"+
											 "    <MSGTYPE>104</MSGTYPE>"+
											 "    <SUB>"+sub1+"</SUB>"+
					  						 "    <CONT>"+cont1+"</CONT>"+
											 "    <URL></URL>";
						xml_data1 += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
						xml_data1 += "    <SENDER></SENDER>"+
			  								 "    <MSGICON>10</MSGICON>"+
											 "    <MSGSAVE>1</MSGSAVE>"+
			  								 "    <LEAVEDMSG>1</LEAVEDMSG>"+
											 "    <FLDTYPE>1</FLDTYPE>"+
			  								 "  </ALERTMSG>"+
											 "</COOLMSG>";
						CdAlertBean msg1 = new CdAlertBean();
						msg1.setFlddata(xml_data1);
						msg1.setFldtype("1");
		
						boolean flag_msg1 = cm_db.insertCoolMsg(msg1);
					}
				}
			}
		}
	}else if(mode.equals("D")){	//삭제
		if(!param.equals("")){
			String [] l_cd_arr = param.split("//");
			int cnt=0;
			for(int i=0; i<l_cd_arr.length; i++){
				flag = cop.deleteEcarChargerOne(l_cd_arr[i]);
				if(flag==true){		cnt ++;							}
			}
			if(cnt == l_cd_arr.length){		flag=true;	}else{		flag=false;		}
		}else{
			flag = cop.deleteEcarChargerOne(l_cd);
		}
	}
	
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src='/include/common.js'></script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post'>
<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" name="inst_zip" value="">
<input type="hidden" name="inst_loc" value="">
<input type="hidden" name="rent_l_cd" value="<%=l_cd%>">
<input type="hidden" name="rent_mng_id" value="<%=m_id%>">
<input type="hidden" name="client_id" value="<%=client_id%>">
</form>
<script type="text/javascript">
<%if(flag){%>
	<%if(mode.equals("I")){%>
		<%if(error_msg.equals("")){%>
			alert("등록되었습니다.");	
		<%}else{%>
			alert('<%=error_msg%>');
		<%}%>
		parent.opener.location.reload();
		location.href='ecar_charg_pop.jsp';
	<%}else if(mode.equals("U")){%>
		alert("수정되었습니다.");
		location.href='ecar_charg_pop.jsp?rent_l_cd=<%=l_cd%>&rent_mng_id=<%=m_id%>&mode=U';
		parent.opener.location.reload();
	<%}else if(mode.equals("U_ALL")){%>
		alert("수정되었습니다.");
		window.close();
		parent.opener.location.reload();
	<%}else if(mode.equals("D")){%>
		alert("삭제되었습니다.");
		window.close();
		parent.opener.location.reload();
	<%}%>
<%}else{%>
	alert("오류발생! 관리자에게 문의하세요.");
	history.back();
<%}%>
</script>
</body>
</html>