<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*" %>
<%@ page import="acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<rows>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	//String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String period_gubun = request.getParameter("period_gubun")==null?"":request.getParameter("period_gubun");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"2":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String branch = request.getParameter("branch")==null?"":request.getParameter("branch");		//영업지점 검색추가
	String bus_user_id = request.getParameter("bus_user_id")==null?"":request.getParameter("bus_user_id");		//통화작성자 검색추가
	String cmd = "";
	
	if(!gubun4.equals("3")){
		s_dt = "";
		e_dt = "";
	}

	if(user_id.equals("")) 	user_id = ck_acar_id;
	
	String est_st = "";
	String answer = "";
	String b_note = "";
	String client = "";
	String name = "";
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();	

	//EstiSpeBean [] e_r = e_db.getEstiSpeList(gubun1, period_gubun, gubun3, gubun4, s_dt, e_dt, s_kd, t_wd, esti_m, esti_m_dt, esti_m_s_dt, esti_m_e_dt, branch );
	EstiSpeBean [] e_r = e_db.getEstiSpeList2(gubun1, period_gubun, gubun3, gubun4, s_dt, e_dt, s_kd, t_wd, esti_m, esti_m_dt, esti_m_s_dt, esti_m_e_dt, branch, bus_user_id);
	int size = e_r.length +1;
	System.out.println(e_r.length);
   
	if (e_r.length > 0 ) {
			 
		for (int i=0; i < e_r.length; i++) {
			
			bean = e_r[i];
			
			if(bean.getEst_st().equals("PM1")||bean.getEst_st().equals("PM2")||bean.getEst_st().equals("PM3")) continue;
			
			String rent_yn = bean.getRent_yn().replaceAll("[\r\n]", " ");
			String etc = bean.getEtc().replaceAll("[\r\n]", " ");
			
			size = size -1;
			
			//구분1
			if(bean.getEst_st().equals("B")||bean.getEst_st().equals("P")){
	 	 		est_st = "M";
	 	 	}else if(bean.getEst_st().equals("M")||bean.getEst_st().equals("N")){
	 	 		est_st = "월";
	 	 	}else if(bean.getEst_st().equals("MSB")||bean.getEst_st().equals("MSP")||bean.getEst_st().equals("MS1")||bean.getEst_st().equals("MS2")||bean.getEst_st().equals("MS3") ){
	 	 		est_st = "M신";
	 	 	}else if(bean.getEst_st().equals("MJB")||bean.getEst_st().equals("MJP") || bean.getEst_st().equals("MJ1")||bean.getEst_st().equals("MJ2")||bean.getEst_st().equals("MJ3")){
	 	 		est_st = "M재";
	 	 	}else if(bean.getEst_st().equals("MMB")||bean.getEst_st().equals("MMP")){
	 	 		est_st = "M월";
	 	 	}else if(bean.getEst_st().equals("PS1")||bean.getEst_st().equals("PS2")||bean.getEst_st().equals("PS3")){
	 	 		est_st = "P신";
	 	 	}else if(bean.getEst_st().equals("PJ1")||bean.getEst_st().equals("PJ2")||bean.getEst_st().equals("PJ3")){
	 	 		est_st = "P재";
	 	 	}else if(bean.getEst_st().equals("PM1")||bean.getEst_st().equals("PM2")||bean.getEst_st().equals("PM3")){
	 	 		est_st = "P월";
	 	 	}else if(bean.getEst_st().equals("PE9")) {
	 	 		est_st = "P전";
	 	 	}else if(bean.getEst_st().equals("PH9")) {
	 	 		est_st = "P수";
	 	 	}else if(bean.getEst_st().equals("ME9")) {
	 	 		est_st = "M전";
	 	 	}else if(bean.getEst_st().equals("MH9")) {
	 	 		est_st = "M수";
	 	 	}else if(bean.getEst_st().equals("PC4")) {
	 	 		est_st = "P상";
	 	 	}else if(bean.getEst_st().equals("MO4")) {
	 	 		est_st = "M상";
	 	 	}else if(bean.getEst_st().equals("ARS")) {
	 	 		est_st = "A상";
	 	 	}else{
	 	 		est_st = "";
	 	 	}
			
			//통화2
	 	 	if((bean.getM_reg_dt().equals("") && bean.getB_reg_dt().equals("") && bean.getT_reg_dt().equals(""))){
		 	 	answer = "통화^javascript:EstiMemo(&#39;"+bean.getEst_id()+"&#39;, &#39;"+user_id+"&#39;, &#39;1&#39;, &#39;&#39;, &#39;&#39;);^_self";
	 	 	}else{
	 	 		//통화거나 부재중이거나 결번이거나
	 	 		if( !bean.getT_reg_dt().equals("") ){
	 	 			answer = AddUtil.ChangeDate6(bean.getT_reg_dt()) +" "+c_db.getNameById(bean.getT_user_id(), "USER_DE")+" "+c_db.getNameById(bean.getT_user_id(), "USER")+"^javascript:EstiMemo(&#39;"+bean.getEst_id()+"&#39;, &#39;"+user_id+"&#39;, &#39;2&#39;, &#39;"+bean.getB_reg_dt()+"&#39;, &#39;"+bean.getT_reg_dt()+"&#39;);^_self";
	 	 		}else{
	 	 			 if( !bean.getB_note().equals("") ){
	 	 				answer = AddUtil.ChangeDate6(bean.getB_reg_dt()) +" "+bean.getB_note()+"^javascript:EstiMemo(&#39;"+bean.getEst_id()+"&#39;, &#39;"+user_id+"&#39;, &#39;2&#39;, &#39;"+bean.getB_reg_dt()+"&#39;, &#39;"+bean.getT_reg_dt()+"&#39;);^_self";//
	 	 			 }
	 	 		}
	 	 	}
			
	 	 	 //상담결과3
	 	 	if ( !bean.getB_note().equals("") ){
	 	 		b_note =  bean.getB_note();
	 	 	}else{
	 	 		b_note =  rent_yn;	
	 	 	}
	 	 	 
	 		 //고객구분5
	 	 	if(bean.getEst_st().equals("1")||bean.getEst_st().equals("B")||bean.getEst_st().equals("M")||bean.getEst_st().equals("PS1")||bean.getEst_st().equals("PJ1")||bean.getEst_st().equals("PM1")||bean.getEst_st().equals("MSB")||bean.getEst_st().equals("MJB")||bean.getEst_st().equals("MMB") ||bean.getEst_st().equals("MS1")||bean.getEst_st().equals("MJ1") ){
	 	 		client =  "법인";
	 	 	}else if(bean.getEst_st().equals("2")||bean.getEst_st().equals("P")||bean.getEst_st().equals("N")||bean.getEst_st().equals("PS2")||bean.getEst_st().equals("PJ2")||bean.getEst_st().equals("PM2")||bean.getEst_st().equals("MSP")||bean.getEst_st().equals("MJP")||bean.getEst_st().equals("MMP") ||bean.getEst_st().equals("MS2")||bean.getEst_st().equals("MJ2")){
	 	 		client =  "개인사업자";
	 	 	}else if(bean.getEst_st().equals("PE9")||bean.getEst_st().equals("PH9")||bean.getEst_st().equals("ME9")||bean.getEst_st().equals("MH9")){
	 	 		client =  "사전예약";
	 	 	}else if(bean.getEst_st().equals("PC4")||bean.getEst_st().equals("MO4")){
	 	 		client =  "간편상담";
	 	 	}else if(bean.getEst_st().equals("ARS")){
	 	 		client =  "ARS상담";
	 	 	}else{
	 	 		client =  "개 인";
	 	 	}
	 	 	 
	 	 	//성명/법인명6
	 		if(bean.getClient_yn().equals("Y")){
	 			name = "<b>기존고객-"+bean.getEst_nm() + "</b>";
			}else{
				name = bean.getEst_nm();
			}
	 	 	
	 		//영업지점8
	 		if(bean.getEst_st().equals("ARS")){
	 			
	 			if (bean.getEst_area().equals("서울")) {
					if (bean.getCounty().equals("송파")) {
						branch = "송파";
					} else if (bean.getCounty().equals("광화문")) {
						branch = "광화문";
					} else if (bean.getCounty().equals("강남")) {
						branch = "강남";
					} else {
						branch = "본사";
					}				
				} else if (bean.getEst_area().equals("부산")) {
					branch = "부산";
				} else if (bean.getEst_area().equals("대전")) {
					branch = "대전";
				} else if (bean.getEst_area().equals("인천")) {
					branch = "인천";
				} else if (bean.getEst_area().equals("대구")) {
					branch = "대구";
				} else if (bean.getEst_area().equals("광주")) {
					branch = "광주";
				} else if (bean.getEst_area().equals("수원")) {
					branch = "수원";
				}
	 	 		
	 	 	} else {
	 	 		
				if(bean.getEst_area().equals("서울")){
					if(bean.getCounty().equals("강남구")||bean.getCounty().equals("서초구")||bean.getCounty().equals("성동구")){
						branch = "강남";
					}else if(bean.getCounty().equals("종로구")||bean.getCounty().equals("동대문구")||bean.getCounty().equals("중구")||bean.getCounty().equals("용산구")||bean.getCounty().equals("중랑구")||bean.getCounty().equals("노원구")||bean.getCounty().equals("성북구")||bean.getCounty().equals("서대문구")||bean.getCounty().equals("은평구")||bean.getCounty().equals("도봉구")||bean.getCounty().equals("강북구")) {
						branch = "광화문";
					}else if(bean.getCounty().equals("송파구")||bean.getCounty().equals("강동구")||bean.getCounty().equals("광진구")) {
						branch = "송파";
					}else{
						branch = "본사";
					}
				}else if(bean.getEst_area().equals("인천")){
					branch = "인천";
				}else if(bean.getEst_area().equals("경기")){
					if(bean.getCounty().equals("과천시")){
						branch = "강남";
					}else if(bean.getCounty().equals("김포시")||bean.getCounty().equals("부천시")||bean.getCounty().equals("시흥시")){
						branch = "인천";
					}else if(bean.getCounty().equals("군포시")||bean.getCounty().equals("수원시")||bean.getCounty().equals("안산시")||bean.getCounty().equals("안성시")||bean.getCounty().equals("여주군")||bean.getCounty().equals("오산시")||bean.getCounty().equals("용인시")||bean.getCounty().equals("의왕시")||bean.getCounty().equals("이천시")||bean.getCounty().equals("평택시")||bean.getCounty().equals("화성시")){
						branch = "수원";
					}else if(bean.getCounty().equals("가평군")||bean.getCounty().equals("성남시")||bean.getCounty().equals("하남시")||bean.getCounty().equals("광주시")||bean.getCounty().equals("남양주시")||bean.getCounty().equals("양평군")||bean.getCounty().equals("구리시")){
						branch = "송파";
					}else if(bean.getCounty().equals("동두천시")||bean.getCounty().equals("양주시")||bean.getCounty().equals("연천군")||bean.getCounty().equals("의정부시")||bean.getCounty().equals("포천시")){
						branch = "광화문";
					}else{
						branch = "본사";
					}
				}else if(bean.getEst_area().equals("강원")){
					if(bean.getCounty().equals("춘천시")||bean.getCounty().equals("양구군")||bean.getCounty().equals("철원군")||bean.getCounty().equals("화천군")||bean.getCounty().equals("홍천군")||bean.getCounty().equals("인제군")||bean.getCounty().equals("고성군")||bean.getCounty().equals("속초시")||bean.getCounty().equals("양양군")){
						branch = "송파";
					}else{
						branch = "수원";
					}
				}else if(bean.getEst_area().equals("경남")||bean.getEst_area().equals("부산")||bean.getEst_area().equals("울산")){
					branch = "부산";
				}else if(bean.getEst_area().equals("전남")||bean.getEst_area().equals("광주")||bean.getEst_area().equals("제주")||bean.getEst_area().equals("전북")){
					branch = "광주";
				}else if(bean.getEst_area().equals("대구")||bean.getEst_area().equals("경북")){
					branch = "대구";
				}else if(bean.getEst_area().equals("충남")||bean.getEst_area().equals("충북")||bean.getEst_area().equals("대전")||bean.getEst_area().equals("세종")){
					branch = "대전";
				}
	 	 	}
		//	out.println("id:" +user_id);
		%>
			
		<row  id='<%=i+1%>'>
			<cell><![CDATA[<input type="checkbox" name="content_check" value="<%=bean.getEst_id()%>">]]></cell><!--체크박스-->
			<cell><![CDATA[<%=size%>]]></cell><!--연번0-->
 	 		<cell><![CDATA[<%=est_st%>]]></cell><!--구분1-->
	 	 	<cell><![CDATA[<%=answer%>]]></cell><!--통화2-->
 	 		<cell><![CDATA[<%=b_note%>]]></cell><!--상담결과3-->
	 	 	<cell><![CDATA[<%=AddUtil.ChangeDate3(bean.getReg_dt())%>]]></cell><!--신청일자4-->
	 		<cell><![CDATA[<%=client%>]]></cell><!--고객구분5-->
			<cell><![CDATA[<%=name%>]]></cell><!--성명/법인명6-->			
	 	 	<cell>
	 	 		<![CDATA[
	 	 			<%if (!bean.getEst_st().equals("ARS")) {%>
		 	 			<%=bean.getEst_area()%>
	 	 			<%}%>
	 	 		]]>
	 	 	</cell><!--지역7-->
			<cell>
				<![CDATA[
					<%if (bean.getEst_st().equals("MMB") || bean.getEst_st().equals("MMP")) { // 월렌트(모바일)%>
						<%if(bean.getEst_area().equals("수도권")){ // 월렌트 건이더라도 차량현위치가 수도권인 경우 고객 주소에 따른 영업지점 노출 %>
							<%=branch%>
		 	 			<%} else { // 수도권 외 지역은 차량 현위치에 따른 지역 컬럼 값 노출 %>
							<%=bean.getEst_area()%>
		 	 			<%}%>
	 	 			<%} else {%>
						<%=branch%>
	 	 			<%}%>
				]]>
			</cell><!--영업지점8-->	
			<cell><![CDATA[<%=bean.getEst_agnt()%>]]></cell><!--담당자9-->
	 	 	<%-- <cell><![CDATA[<%=AddUtil.phoneFormatAsterisk(bean.getEst_tel())%>]]></cell> --%><!--전화번호10-->
	 	 	<cell><![CDATA[<%=AddUtil.phoneFormat(bean.getEst_tel())%>]]></cell><!--전화번호10-->
	 		<cell>
	 			<![CDATA[
	 				<%if (bean.getEst_st().equals("PE9") || bean.getEst_st().equals("PH9") || bean.getEst_st().equals("ME9") || bean.getEst_st().equals("MH9")) {%>
 	 					<font style="color:red;">사전예약</font> - <%=bean.getCar_nm()%>
 	 				<%} else if (bean.getEst_st().equals("PC4") || bean.getEst_st().equals("MO4")) {%>
 	 					<font style="color:blue;">간편상담신청</font>
 	 				<%} else if (bean.getEst_st().equals("ARS")) {%>
 	 					<font style="color:green;">ARS상담신청</font>
 	 				<%} else {%>
 	 					<%=bean.getCar_nm()%>
 	 				<%}%>
	 			]]>
	 		</cell><!--희망차종14-->
	 	</row>
	<%}
	}%>

</rows>
