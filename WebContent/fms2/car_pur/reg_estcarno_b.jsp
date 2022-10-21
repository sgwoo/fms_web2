<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<body leftmargin="15">
<%
	//차량번호 자동 수정 위한 변수들
	String param 	= request.getParameter("param")==null? "":request.getParameter("param");
	String[] params = param.split(",");
	String errorText = "";
	String alertText = "";
	String udtStText = "";
	String successText = "";
	String type = "";
	String query1 = "";
	String query2 = "";
	int paramCnt = params.length;
	int count = 0;
	int flag1 = 0;
	int flag2 = 0;
	
	//차량번호 맞바꾸기 위한 변수들
	String car_no1 		= request.getParameter("car_no1")==null?"":request.getParameter("car_no1");
	String car_no2 		= request.getParameter("car_no2")==null?"":request.getParameter("car_no2");
	String rent_l_cd1 	= request.getParameter("rent_l_cd1")==null?"":request.getParameter("rent_l_cd1");
	String rent_l_cd2 	= request.getParameter("rent_l_cd2")==null?"":request.getParameter("rent_l_cd2");
	String car_nm1 		= request.getParameter("car_nm1")==null?"":request.getParameter("car_nm1");
	String car_nm2 		= request.getParameter("car_nm2")==null?"":request.getParameter("car_nm2");
	
	//차량번호 맞바꾸기 
	if(!car_no1.equals("")&&!car_no2.equals("")&&!car_nm1.equals("")&&!car_nm2.equals("")&&!rent_l_cd1.equals("")&&!rent_l_cd2.equals("")){
		
		type = "exchange";
		int s_cnt1 = sc_db.changeCarNoMapping1(car_no1, rent_l_cd2);
		int s_cnt2 = sc_db.changeCarNoMapping2(car_no1, rent_l_cd2, car_nm2);
		int s_cnt3 = sc_db.changeCarNoMapping1(car_no2, rent_l_cd1);
		int s_cnt4 = sc_db.changeCarNoMapping2(car_no2, rent_l_cd1, car_nm1);
		if(s_cnt1==1 && s_cnt3==1 ){	flag1 = 1;	}
		if(s_cnt2==1 && s_cnt4==1 ){	flag2 = 1;	}
		
	}else{	//차량번호 자동 지정
		
		type = "auto";
		//여러건 자동 등록전 하나라도 빈 번호가 모지라면 아예 실행이 되지 않게 카운트 먼저 체크(요청사항)
		int cntChk = 0;	// 해당 등록지의 빈 번호 수
		int incheon_cnt = 0; 
		int ext_cnt1 = 0;	//인천 카운트
		int ext_cnt2 = 0;	//부산 카운트
		int ext_cnt3 = 0;	//대전 카운트
		int ext_cnt4 = 0;	//대구 카운트
		int ext_cnt5 = 0;	//고객 카운트
		for(int i=0; i<params.length; i++){
			Vector vt = a_db.getParamForRegCarNo(params[i]);		
			int vt_size = vt.size();
			for(int j = 0 ; j < vt_size ; j++){
				Hashtable ht = (Hashtable)vt.elementAt(j);
				String udt_st_ext = ht.get("UDT_ST_EXT").toString();
				if(udt_st_ext.equals("인천")) ext_cnt1 ++;
				if(udt_st_ext.equals("부산")) ext_cnt2 ++;
				if(udt_st_ext.equals("대전")) ext_cnt3 ++;
				if(udt_st_ext.equals("대구")) ext_cnt4 ++;
				if(udt_st_ext.equals("고객")) ext_cnt5 ++;
			}
		}
		
		Hashtable countList = sc_db.getCarExtCount();
	 	//등록 가능한 번호 개수가 모자라면 자동등록 수행하지 않음
		if(ext_cnt1 > Integer.parseInt((String)countList.get("CNT1"))){		udtStText += "인천, ";	type = "autoError";		}
		if(ext_cnt2 > Integer.parseInt((String)countList.get("CNT2"))){		udtStText += "부산, ";	type = "autoError";		}
		if(ext_cnt3 > Integer.parseInt((String)countList.get("CNT3"))){		udtStText += "대전, ";	type = "autoError";		}
		if(ext_cnt4 > Integer.parseInt((String)countList.get("CNT4"))){		udtStText += "대구, ";	type = "autoError";		}
		
		if(type.equals("auto")){	//지역별로 번호가 충분한 경우 - 자동등록 
			for(int i=0; i<params.length; i++){
				Vector vt = a_db.getParamForRegCarNo(params[i]);		
				int vt_size = vt.size();
				for(int j = 0 ; j < vt_size ; j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					String m_id = ht.get("RENT_MNG_ID").toString();
					String l_cd = ht.get("RENT_L_CD").toString();
					String car_no = ht.get("CAR_NO").toString();
					String car_nm = ht.get("CAR_NM").toString();
					String udt_st = ht.get("UDT_ST").toString();
					String udt_st_ext = ht.get("UDT_ST_EXT").toString();
					
					if(udt_st.equals("고객")){	//인수지가 고객인 경우는 자동등록에서 제외 처리
						udtStText += l_cd + "<br>";
						count ++;
					}else{
						
						if(!car_no.equals("")){	// 이미 차량번호가 등록되어 있으면 자동등록은 시키지않음
							errorText += l_cd+" ("+car_no+")<br>";					
							count ++;
						}else{	//차량번호가 등록되지 않은 경우만 자동차량 등록 시킴
							Vector lists = sc_db.getNewCarNumList("","", udt_st_ext, "2","","");
							Hashtable list = (Hashtable)lists.elementAt(0);
							car_no = (String)list.get("CAR_NO");
							
							//번호와 계약을 연동
							query1 = " UPDATE car_pur SET est_car_no =replace('"+car_no+"','-','') WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
							query2 = " UPDATE car_scrap SET rent_l_cd ='"+l_cd+"', car_nm = '"+car_nm+"',"+
									 " upd_dt = to_char(sysdate,'YYYYMMDD'), auto_yn = 'Y'"+
									 " WHERE car_no='"+car_no+"'";
							flag1 = a_db.updateEstDt(query1);
							flag2 = sc_db.updateCarScrap(query2);
							
							//카운트 처리VV
							if(flag1 == 1 && flag2 == 1){
								successText += l_cd+" --> "+car_no+" ("+udt_st_ext+")<br> ";
								count ++;
							}
						}
					}
				}
			} 
		}
	}
%>
<script language='javascript'>
var errorText = '<%=errorText%>';
var alertText = '<%=alertText%>';
var udtStText = '<%=udtStText%>';
var successText = '<%=successText%>';

<%	if(type.equals("auto")){
		if(paramCnt != count){%>
			alert("등록 중 에러발생! 건별로 등록 중 누락된 경우이니 확인바랍니다.");
			parent.window.close();
			parent.opener.location.reload();
<%		}else{		%>	
			var resultText = "";
			if(errorText!=""){
				resultText += "<div>"+errorText+"</div><br>";
				resultText += "<div>상기 계약은 이미 등록된 차량번호가 있어 자동등록에서 제외 되었습니다.</div><br><br>";
			}
			if(alertText!=""){
				resultText += "<div>"+alertText+"</div><br>";
				resultText += "<div>상기 계약은 사용할 번호가 없어서 자동등록에서 제외되었습니다.</div>";
				resultText += "<div>대폐차관리\신규자동차번호관리 에서 번호를 생성해주세요.</div><br><br>";
			}
			if(udtStText!=""){
				resultText += "<div>"+udtStText+"</div><br>";
				resultText += "<div>상기 계약은 인수지가 <고객> 이어서 자동등록에서 제외 되었습니다.</div><br><br>";
			}
			if(successText!=""){
				resultText += "<div>"+successText+"</div><br>";
				resultText += "<div>상기 계약은 정상 처리되었습니다.</div><br>";
			}
			alert("자동등록이 정상 완료되었습니다.");
			$(document).ready(function(){
				$("#result_div").html(resultText);
			})
			//parent.window.close();
			parent.opener.location.reload();
<%		}
	}else if(type.equals("exchange")){
		if(flag1 == 0 || flag2 == 0){	%>
			alert("처리되지 않았습니다.");
			location='about:blank';	
<%		}else{	%>
			alert("처리되었습니다.");
			parent.window.close();
			parent.opener.location.reload();
<%		}
	}else if(type.equals("autoError")){	%>	
		alert(udtStText + "\n\n다음 지역의 등록가능번호가 선택한 계약건보다 모자랍니다.\n\n번호를 등록 후 다시 시도해주세요.");
		parent.window.close();
<%	}	%>
</script>
	<div id="result_div" style="margin-top: 30px; margin-left: 30px;"></div>
	<div style="margin-left: 30px;" align="center">
		<input type="button" class="button" value="닫기" onclick="window.close();">
	</div>
</body>
</html>
