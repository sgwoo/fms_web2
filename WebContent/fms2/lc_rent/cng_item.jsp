<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.client.*,acar.common.*, acar.user_mng.*, acar.settle_acc.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String rent_st  	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"1":request.getParameter("fee_rent_st");
	String cmd	  	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String c_st = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	

	
	if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp")){
		Hashtable cont_ht = s_db.getContSettleInfo(rent_l_cd);
		if(!String.valueOf(cont_ht.get("RENT_L_CD")).equals("")){
			rent_mng_id = String.valueOf(cont_ht.get("RENT_MNG_ID"));
			rent_st 	= String.valueOf(cont_ht.get("RENT_ST"));
		}
	}
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	
	//영업소리스트
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	Vector vt = a_db.getLcRentCngHList(rent_mng_id, rent_l_cd, cng_item);
	int vt_size = vt.size();
	
	String item_nm = "";
	if(cng_item.equals("bus_id2")) 		item_nm = "영업담당자";
	if(cng_item.equals("mng_id")) 		item_nm = "관리담당자";
	if(cng_item.equals("mng_id2")) 		item_nm = "예비배정자";
	if(cng_item.equals("car_st")) 		item_nm = "용도구분";
	if(cng_item.equals("rent_way")) 	item_nm = "관리구분";
	if(cng_item.equals("mng_br_id")) 	item_nm = "관리지점";
	if(cng_item.equals("grt_amt")) 		item_nm = "보증금";
	if(cng_item.equals("pp_amt")) 		item_nm = "선납금";
	if(cng_item.equals("ifee_amt")) 	item_nm = "개시대여료";
	if(cng_item.equals("fee_amt")) 		item_nm = "대여료";
	if(cng_item.equals("inv_amt")) 		item_nm = "정상대여료";
	if(cng_item.equals("bus_st")) 		item_nm = "영업구분";
	if(cng_item.equals("est_area"))		item_nm = "차량이용지역";
	if(cng_item.equals("bus_id")) 		item_nm = "최초영업자";	
	if(cng_item.equals("bus_agnt_id")) 	item_nm = "영업대리인";
	if(cng_item.equals("opt_amt")) 		item_nm = "매입옵션";
	if(cng_item.equals("suc_cls_dt")) 	item_nm = "승계해지일자";
	
	Vector vt2 = new Vector();
	//영업담당자인 경우 동일거래처의 영업담당자가 여러명일때 리스트 확인
	if(cng_item.equals("bus_id2")){
		vt2 = a_db.getLcRentClientBusid2(base.getClient_id());
	}
	int vt_size2 = vt2.size();
	
		
	//지역별 메세지 받기 설정.
	
	String mode = "";		
	String s_br = "";		
	String est_area = cont_etc.getEst_area();
	String county = cont_etc.getCounty();

	if(est_area.equals("서울")){
		if(county.equals("강남구")||county.equals("강동구")||county.equals("광진구")||county.equals("동대문구")||county.equals("서초구")||county.equals("성동구")||county.equals("송파구")||county.equals("중랑구")){
			mode = "MESSAGE_K";
			s_br = "S2";
		}else{
			mode = "MESSAGE_S";
			s_br = "S1";
		}
	}else if(est_area.equals("경기")){
		if(county.equals("과천시")||county.equals("성남시")||county.equals("하남시")||county.equals("광주시")){
			mode = "MESSAGE_K";
			s_br = "S2";
		}else if(county.equals("김포시")||county.equals("부천시")||county.equals("시흥시")){
			mode = "MESSAGE_I";
			s_br = "I1";
		}else if(county.equals("고양시")||county.equals("광명시")||county.equals("안양시")||county.equals("파주시")){
			mode = "MESSAGE_S";
			s_br = "S1";
		}else if(county.equals("군포시")||county.equals("수원시")||county.equals("안산시")||county.equals("안성시")||county.equals("여주군")||county.equals("오산시")||county.equals("용인시")||county.equals("의왕시")||county.equals("이천시")||county.equals("평택시")||county.equals("화성시")){
			mode = "MESSAGE_W";
			s_br = "K3";
		}else if(county.equals("가평군")||county.equals("구리시")||county.equals("남양주시")||county.equals("동두천시")||county.equals("양주시")||county.equals("양평군")||county.equals("연천군")||county.equals("의정부시")||county.equals("포천시")){
			mode = "MESSAGE_S";	//광화문지점 생서시 광화문지점으로 변경.		
			s_br = "S1";
		}else{
			mode = "MESSAGE_S";
			s_br = "S1";
		}
	}else if(est_area.equals("인천")){		
			mode = "MESSAGE_I";
			s_br = "I1";		
	}else if(est_area.equals("강원")){
		if(county.equals("춘천시")||county.equals("양구군")||county.equals("철원군")||county.equals("화천군")||county.equals("홍천군")||county.equals("인제군")||county.equals("고성군")||county.equals("속초시")||county.equals("양양군")){
			mode = "MESSAGE_S";
			s_br = "S1";
		}else if(county.equals("원주시")||county.equals("횡성군")||county.equals("평창군")||county.equals("강릉시")||county.equals("정선군")||county.equals("영월군")||county.equals("태백시")||county.equals("동해시")||county.equals("삼척시")){
			mode = "MESSAGE_W";
			s_br = "K3";
		}
	}else if(est_area.equals("경남")||est_area.equals("부산")||est_area.equals("제주") ){
		mode = "MESSAGE_B";
		s_br = "B1";
	}else if( est_area.equals("울산") ){
		mode = "MESSAGE_U";
		s_br = "U1";	
	}else if(est_area.equals("전남")||est_area.equals("광주")){
		mode = "MESSAGE_J";
		s_br = "J1";
	}else if(est_area.equals("전북")){
		if(county.equals("군산시")||county.equals("김제시")||county.equals("익산시")||county.equals("전주시")){
			mode = "MESSAGE_J";
			s_br = "J1";
		}else{
			mode = "MESSAGE_J";
			s_br = "J1";
		}
	}else if(est_area.equals("경북")){
		//if(county.equals("구미시")||county.equals("군위군")||county.equals("김천시")||county.equals("문경시")||county.equals("봉화군")||county.equals("상주시")||county.equals("성주군")||county.equals("안동시")||county.equals("영주시")||county.equals("예천군")||county.equals("울릉군")||county.equals("의성군")||county.equals("칠곡군")){
		//	mode = "MESSAGE_D";
		//	s_br = "D1";
		//}else{
		//	mode = "MESSAGE_B";
		//	s_br = "B1";			
			mode = "MESSAGE_G";
			s_br = "G1";
		//}
	}else if(est_area.equals("대구")){
		//if(county.equals("북구")||county.equals("서구")){
		//	mode = "MESSAGE_D";
		//	s_br = "D1";
		//}else{
		//	mode = "MESSAGE_B";
		//	s_br = "B1";
		//}		
		mode = "MESSAGE_G";
		s_br = "G1";
	}else if(est_area.equals("충남")||est_area.equals("충북")||est_area.equals("대전")||est_area.equals("세종")){
		mode = "MESSAGE_D";
		s_br = "D1";	
	}
	
	if(s_br.equals("S2") || s_br.equals("I1")) s_br = "S1";		//강남, 인천지점 관리담당은 본사에서 
	
	

		



%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		fm = document.form1;
						
		if(fm.new_value.value == ""){		alert("변경후를 입력해 주세요!");		fm.new_value.focus();	return;	}
		
		<%if(item_nm.equals("영업담당자")||item_nm.equals("관리담당자")||item_nm.equals("예비배정자")||item_nm.equals("영업대리인")){%>
		//if(fm.new_value.value.substring(0,1) == '1')	{ alert('부서로 선택되었습니다. 확인해주세요.'); return; }
		<%}%>

		if(fm.cng_cau.value == ""){			alert("변경사유를 입력해 주세요!");		fm.cng_cau.focus();		return;	}
		
		if(!confirm("변경하시겠습니까?"))	return;
		
		fm.target = "i_no";				
		fm.action = "cng_item_a.jsp";
		fm.submit();
	}
	
	<%if(item_nm.equals("보증금")||item_nm.equals("선납금")||item_nm.equals("개시대여료")||item_nm.equals("대여료")||item_nm.equals("정상대여료")||item_nm.equals("매입옵션")){%>
	function set_amt(){
		fm = document.form1;
		if(fm.cng_item.value == 'grt_amt'){
			fm.s_amt.value = fm.new_value.value;
			fm.v_amt.value = '0';
		}else{
			fm.s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.new_value.value))));
			fm.v_amt.value = parseDecimal(toInt(parseDigit(fm.new_value.value)) - toInt(parseDigit(fm.s_amt.value)));			
		}		
	}
	<%}%>
	
	//직원조회
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?mode=EMP_Y&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}			
//-->
</script>
<%if(item_nm.equals("차량이용지역")){%>
<script language='javascript'>
<!--
     	var cnt = new Array();
     	cnt[0] = new Array('구/군');
     	cnt[1] = new Array('구/군','강남구','강동구','강북구','강서구','관악구','광진구','구로구','금천구','노원구','도봉구','동대문구','동작구','마포구','서대문구','서초구','성동구','성북구','송파구','양천구','영등포구','용산구','은평구','종로구','중구','중랑구');
     	cnt[2] = new Array('구/군','강서구','금정구','남구','동구','동래구','부산진구','북구','사상구','사하구','서구','수영구','연제구','영도구','중구','해운대구','기장군');
     	cnt[3] = new Array('구/군','남구','달서구','동구','북구','서구','수성구','중구','달성군');
     	cnt[4] = new Array('구/군','계양구','남구','남동구','동구','미추홀구','부평구','서구','연수구','중구','강화군','옹진군');
     	cnt[5] = new Array('구/군','광산구','남구','동구','북구','서구');
     	cnt[6] = new Array('구/군','대덕구','동구','서구','유성구','중구');
     	cnt[7] = new Array('구/군','남구','동구','북구','중구','울주군');
     	cnt[8] = new Array('구/군','세종특별자치시');
     	cnt[9] = new Array('구/군','고양시','과천시','광명시','구리시','군포시','남양주시','동두천시','부천시','성남시','수원시','시흥시','안산시','안양시','오산시','의왕시','의정부시','평택시','하남시','가평군','광주시','김포시','안성시','양주시','양평군','여주군','연천군','용인시','이천시','파주시','포천시','화성시');
     	cnt[10] = new Array('구/군','강릉시','동해시','삼척시','속초시','원주시','춘천시','태백시','고성군','양구군','양양군','영월군','인제군','정선군','철원군','평창군','홍천군','화천군','횡성군');
     	cnt[11] = new Array('구/군','제천시','청주시','충주시','괴산군','단양군','보은군','영동군','옥천군','음성군','진천군','청원군','증평군');
     	cnt[12] = new Array('구/군','공주시','보령시','서산시','아산시','천안시','금산군','논산군','당진군','부여군','서천군','연기군','예산군','청양군','태안군','홍성군');
     	cnt[13] = new Array('구/군','군산시','김제시','남원시','익산시','전주시','정읍시','고창군','무주군','부안군','순창군','완주군','임실군','장수군','진안군');
     	cnt[14] = new Array('구/군','광양시','나주시','목포시','순천시','여수시','여천시','강진군','고흥군','곡성군','구례군','담양군','무안군','보성군','신안군','여천군','영광군','영암군','완도군','장성군','장흥군','진도군','함평군','해남군','화순군');
     	cnt[15] = new Array('구/군','경산시','경주시','구미시','김천시','문경시','상주시','안동시','영주시','영천시','포항시','고령군','군위군','봉화군','성주군','영덕군','영양군','예천군','울릉군','울진군','의성군','청도군','청송군','칠곡군');
     	cnt[16] = new Array('구/군','거제시','김해시','마산시','밀양시','사천시','울산시','진주시','진해시','창원시','통영시','거창군','고성군','남해군','산청군','양산시','의령군','창녕군','하동군','함안군','함양군','합천군');
     	cnt[17] = new Array('구/군','서귀포시','제주시','남제주군','북제주군');

     	function county_change(add) {
     		var sel=document.form1.county
       		/* 옵션메뉴삭제 */
       		for (i=sel.length-1; i>=0; i--){
        		sel.options[i] = null
        	}
       		/* 옵션박스추가 */
       		for (i=0; i < cnt[add].length;i++){                     
        		sel.options[i] = new Option(cnt[add][i], cnt[add][i]);
        	}         
     	}
//-->
</script>
<%}%>
</head>

<body>
<center>
<form name='form1' action='cng_item_a.jsp' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="cng_item" 		value="<%=cng_item%>">
  <input type='hidden' name="rent_st" 		value="<%=rent_st%>">  
  <input type='hidden' name="cmd" 			value="<%=cmd%>">  
  <input type='hidden' name="cng_size" 		value="<%=vt_size%>">    
    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>담당이력</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='20%'>계약번호</td>
                    <td width='20%' align="center"><%=rent_l_cd%></td>
    			    <td class='title' width='15%'>상호</td>
                    <td width='45%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <%if(item_nm.equals("영업담당자")){%>
                <tr> 
                    <td class='title' width='20%'>차량이용지역</td>
                    <td width='20%' align="center"><%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%></td>
    			    <td class='title' width='15%'>관할지점</td>
                    <td width='45%'>&nbsp;
                        <%if(mode.equals("MESSAGE_S")){%>본사
                        <%}else if(mode.equals("MESSAGE_K")){%>강남지점
                        <%}else if(mode.equals("MESSAGE_I")){%>인천지점
                        <%}else if(mode.equals("MESSAGE_W")){%>수원지점
                        <%}else if(mode.equals("MESSAGE_B")){%>부산지점
                        <%}else if(mode.equals("MESSAGE_J")){%>광주지점
                        <%}else if(mode.equals("MESSAGE_D")){%>대전지점
                        <%}else if(mode.equals("MESSAGE_G")){%>대구지점        
                        <%}else if(mode.equals("MESSAGE_U")){%>울산지점                                        
                        <%}%>
                    </td>
                </tr>                
                <%}%>
            </table>
        </td>
    </tr>  
    <tr> 
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>		  	  
    <tr> 
        <td align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="20%" class='title'>변경전 </td>
                    <td width="20%" class='title'>변경후</td>
                    <td width="30%" class='title' >변경사유</td>
                    <td width="15%" class='title' >변경일자</td>
                    <td width="15%" class='title' >변경자</td>			  
                </tr>
                <%//영업담당자 배정이력리스트
    			
    			if(vt_size > 0){
    				for (int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);
    					String old_value = String.valueOf(ht.get("OLD_VALUE"));
    					String new_value = String.valueOf(ht.get("NEW_VALUE"));%>
                <tr> 
                    <td align="center">
    			<%if(item_nm.equals("영업담당자") || item_nm.equals("관리담당자") || item_nm.equals("예비배정자") || item_nm.equals("최초영업자") || item_nm.equals("영업대리인"))	{%><%=c_db.getNameById(old_value, "USER")%>
    			<%}else if(item_nm.equals("용도구분"))									{%><%if(old_value.equals("1")){%>렌트<%  }else if(old_value.equals("2")){%>예비<%  }else if(old_value.equals("3")){%>리스<%  }else if(old_value.equals("5")){%>용도구분<%}%>
    			<%}else if(item_nm.equals("관리구분"))									{%><%if(old_value.equals("1")){%>일반식<%}else if(old_value.equals("3")){%>기본식<%}%>
    			<%}else if(item_nm.equals("관리지점"))									{%><%=c_db.getNameById(old_value,"BRCH")%>
    			<%}else if(item_nm.equals("보증금") || item_nm.equals("선납금") || item_nm.equals("개시대여료") || item_nm.equals("대여료")||item_nm.equals("정상대여료")||item_nm.equals("매입옵션")){%><%=AddUtil.parseDecimal(AddUtil.replace(old_value,",",""))%>
			    <%}else if(item_nm.equals("영업구분"))									{%><%if(old_value.equals("1")){%>인터넷<%}else if(old_value.equals("2")){%>영업사원<%}else if(old_value.equals("3")){%>업체소개<%}else if(old_value.equals("4")){%>catalog<%}else if(old_value.equals("5")){%>전화상담<%}else if(old_value.equals("6")){%>기존업체<%}else if(old_value.equals("7")){%>에이젼트<%}else if(old_value.equals("8")){%>모바일<%}%>
    			<%}else if(item_nm.equals("차량이용지역"))								{%><%=old_value%>
    			<%}else{%><%=old_value%>
    			<%}%>
    		    </td>
            <td align="center">
    			<%if(item_nm.equals("영업담당자") || item_nm.equals("관리담당자") || item_nm.equals("예비배정자") || item_nm.equals("최초영업자") || item_nm.equals("영업대리인"))	{%><%=c_db.getNameById(new_value, "USER")%>
    			<%}else if(item_nm.equals("용도구분"))									{%><%if(new_value.equals("1")){%>렌트<%  }else if(new_value.equals("2")){%>예비<%  }else if(new_value.equals("3")){%>리스<%  }else if(new_value.equals("5")){%>업무대여<%}%>
    			<%}else if(item_nm.equals("관리구분"))									{%><%if(new_value.equals("1")){%>일반식<%}else if(new_value.equals("3")){%>기본식<%}%>
    			<%}else if(item_nm.equals("관리지점"))									{%><%=c_db.getNameById(new_value,"BRCH")%>
    			<%}else if(item_nm.equals("보증금") || item_nm.equals("선납금") || item_nm.equals("개시대여료") || item_nm.equals("대여료")||item_nm.equals("정상대여료")||item_nm.equals("매입옵션")){%><%=AddUtil.parseDecimal(AddUtil.replace(new_value,",",""))%>
			    <%}else if(item_nm.equals("영업구분"))									{%><%if(new_value.equals("1")){%>인터넷<%}else if(new_value.equals("2")){%>영업사원<%}else if(new_value.equals("3")){%>업체소개<%}else if(new_value.equals("4")){%>catalog<%}else if(new_value.equals("5")){%>전화상담<%}else if(new_value.equals("6")){%>기존업체<%}else if(new_value.equals("7")){%>에이젼트<%}else if(new_value.equals("8")){%>모바일<%}%>
    			<%}else if(item_nm.equals("차량이용지역"))								{%><%=new_value%>
    			<%}else{%><%=new_value%>
    			<%}%>
    		    </td>
                    <td align="center" >
                  	<%=ht.get("CNG_CAU")%>  
    		    </td>
                    <td align="center" >
                  	<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%>  
    		    </td>
                    <td align="center" >
                  	<%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")), "USER")%>
    		    </td>
                </tr>
    		<%  		}
    			}
    		%>		
            </table>
        </td>
    </tr>
    <!--수정가능자-->
    <%if(!cmd.equals("view") && !item_nm.equals("정상대여료")){%>
    <%	String cng_auth = "";%>	  
    <%	if(item_nm.equals("최초영업자")||item_nm.equals("영업담당자")||item_nm.equals("관리담당자")||(!base.getCar_st().equals("4") && item_nm.equals("영업대리인"))||item_nm.equals("예비배정자")||item_nm.equals("관리지점")){ 		
    		if(nm_db.getWorkAuthUser("영업담당자변경",ck_acar_id)){ 	
    			cng_auth = "r"; 
    		}else{
    			if(base.getBus_id().equals(ck_acar_id) && item_nm.equals("최초영업자") && !cont_etc.getSpe_est_id().equals("") && base.getUse_yn().equals("")){
    				cng_auth = "r"; 
    			}
    		}
    	}
    %>
    <%if(base.getCar_st().equals("4") && item_nm.equals("영업대리인")){
    			cng_auth = "r"; 
	    }
    %>   		    
    <%	if(item_nm.equals("차량이용지역")){ 									
    		if(base.getBus_id().equals(ck_acar_id) || base.getBus_id2().equals(ck_acar_id) || nm_db.getWorkAuthUser("영업담당자변경",ck_acar_id)){ 	
    			cng_auth = "r"; 
    		}
    	}
    %>   		
    <%	if(item_nm.equals("용도구분")||item_nm.equals("관리구분")||item_nm.equals("영업구분")){ 			
    		if(nm_db.getWorkAuthUser("대여방식변경", ck_acar_id)){ 	
    			cng_auth = "r"; 
    		}
    	}
    %>		
    <%	if(item_nm.equals("보증금")||item_nm.equals("선납금")||item_nm.equals("개시대여료") ||item_nm.equals("대여료")||item_nm.equals("정상대여료")||item_nm.equals("매입옵션")||item_nm.equals("승계해지일자")){
    		if(nm_db.getWorkAuthUser("회계업무", ck_acar_id)){ 	
    			cng_auth = "r"; 
    			c_st = "fee";
    		}
    	}
    %>	 
    <%if((cmd.equals("입금선수금 수정")||cmd.equals("매월균등발행 입금선수금 수정")) && (item_nm.equals("보증금")||item_nm.equals("선납금")||item_nm.equals("개시대여료"))){ 		cng_auth = "r"; c_st = "fee";}%>
     		
    <%	if(cng_auth.equals("r")){%>	  
    <tr>
	<td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=item_nm%> 변경</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>	
    <tr> 
        <td align="right" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		<tr>
    		    <td width="20%" class='title'>변경전</td>
    		    <td>&nbsp;
    		    <% String old_value2 = "";%>
    		    <%if(item_nm.equals("영업담당자")){
    			    	old_value2 = base.getBus_id2();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("관리담당자")){
    			    	old_value2 = base.getMng_id();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("예비배정자")){
    			    	old_value2 = base.getMng_id2();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("최초영업자")){
    			    	old_value2 = base.getBus_id();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("영업대리인")){
    			    	old_value2 = cont_etc.getBus_agnt_id();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("용도구분")){
    			    	old_value2 = base.getCar_st();%>
    			    <%if(old_value2.equals("1")){%>렌트<%  }else if(old_value2.equals("2")) {%>예비<%  }else if(old_value2.equals("3")){%>리스<%  }else if(old_value2.equals("5")){%>업무대여<%}%>
    			  <%}else if(item_nm.equals("관리구분")){
    			    	old_value2 = fee.getRent_way();%>
    			    <%if(old_value2.equals("1")){%>일반식<%}else if(old_value2.equals("3")){%>기본식<%}%>
    			  <%}else if(item_nm.equals("영업구분")){
    			    	old_value2 = base.getBus_st();%>
    			    <%if(old_value2.equals("1")){%>인터넷<%}else if(old_value2.equals("2")){%>영업사원<%}else if(old_value2.equals("3")){%>업체소개<%}else if(old_value2.equals("4")){%>catalog<%}else if(old_value2.equals("5")){%>전화상담<%}else if(old_value2.equals("6")){%>기존업체<%}else if(old_value2.equals("7")){%>에이젼트<%}else if(old_value2.equals("8")){%>모바일<%}%>
    			  <%}else if(item_nm.equals("관리지점")){
    			    	old_value2 = cont_etc.getMng_br_id();%>
    			    <%=c_db.getNameById(old_value2,"BRCH")%>
    			  <%}else if(item_nm.equals("차량이용지역")){
    			    	old_value2 = cont_etc.getEst_area();%>
    			    <%=old_value2%> <%=cont_etc.getCounty()%>
    			  <%}else if(item_nm.equals("보증금")){
    			    	old_value2 = String.valueOf(fee.getGrt_amt_s());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("선납금")){
    			    	old_value2 = String.valueOf(fee.getPp_s_amt()+fee.getPp_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("개시대여료")){
    			    	old_value2 = String.valueOf(fee.getIfee_s_amt()+fee.getIfee_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("대여료")){
    			    	old_value2 = String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("정상대여료")){
    			    	old_value2 = String.valueOf(fee.getInv_s_amt()+fee.getInv_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("매입옵션")){
    			    	old_value2 = String.valueOf(fee.getOpt_s_amt()+fee.getOpt_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("승계해지일자")){
    			    	old_value2 = cls.getCls_dt();%>
    			    <%=old_value2%>  
    			  <%}%>			  
    			    <input type='hidden' name="old_value" value="<%=old_value2%>">				  
    		    </td>			  
    		</tr>		
    		<tr>
    		    <td width="20%" class='title'>변경후</td>
    		    <td>&nbsp;
    			<%if(item_nm.equals("보증금")||item_nm.equals("선납금")||item_nm.equals("개시대여료")||item_nm.equals("대여료")||item_nm.equals("정상대여료")||item_nm.equals("매입옵션")){%>
    			    <input type='text' name='new_value' size='12' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);set_amt();'>원
    			    &nbsp;&nbsp;&nbsp;&nbsp;
    			    ( 공급가 : <input type='text' name='s_amt' size='10' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);'>원 / 부가세 : <input type='text' name='v_amt' size='10' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);'>원 )
    			  
    			<%}else if(item_nm.equals("영업담당자")||item_nm.equals("관리담당자")||item_nm.equals("예비배정자")||item_nm.equals("최초영업자")||item_nm.equals("영업대리인")){%>
                            <input name="user_nm" type="text" class="text"  readonly value="" size="12"> 
			    <input type="hidden" name="new_value" value="">			
			    <a href="javascript:User_search('new_value', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			    <%}else if(item_nm.equals("승계해지일자")){%>
                <input type="text" name="new_value" value="" size='12' maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>   
    			<%}else{%>
                            <select name="new_value" <%if(item_nm.equals("차량이용지역")){%>onchange="county_change(this.selectedIndex);"<%}%>>
    			    <%if(item_nm.equals("용도구분"))									{%>
                                <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>렌트</option>
                                <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>리스</option>
                                <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>보유</option>
                                <option value="5" <%if(base.getCar_st().equals("5")){%>selected<%}%>>업무대여</option>
    			    <%}else if(item_nm.equals("관리구분"))								{%>
                                <option value='1' <%if(fee.getRent_way().equals("1")){%>selected<%}%>>일반식</option>
                                <option value='2' <%if(fee.getRent_way().equals("2")){%>selected<%}%>>맞춤식</option>
                                <option value='3' <%if(fee.getRent_way().equals("3")){%>selected<%}%>>기본식</option>			  
    			    <%}else if(item_nm.equals("영업구분"))								{%>
                                <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>인터넷</option>
                                <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>모바일</option>
                                <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>전화상담</option>                                
                                <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>영업사원</option>
                                <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>에이젼트</option>
                                <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>기존업체</option>
                                <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>업체소개</option>                                
                                <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog</option>
                                
    			    <%}else if(item_nm.equals("차량이용지역"))								{%>
				<option value=''>시/도</option>
				<option value='서울'>서울특별시</option>
				<option value='부산'>부산광역시</option>
				<option value='대구'>대구광역시</option>
				<option value='인천'>인천광역시</option>
				<option value='광주'>광주광역시</option>
				<option value='대전'>대전광역시</option>
				<option value='울산'>울산광역시</option>
				<option value='세종'>세종특별자치시</option>
				<option value='경기'>경기도</option>
				<option value='강원'>강원도</option>
				<option value='충북'>충청북도</option>
				<option value='충남'>충청남도</option>
				<option value='전북'>전라북도</option>
				<option value='전남'>전라남도</option>
				<option value='경북'>경상북도</option>
				<option value='경남'>경상남도</option>
				<option value='제주'>제주도</option>			  		
    			    <%}else if(item_nm.equals("관리지점"))								{%>
                                <%if(brch_size > 0){
    					for (int i = 0 ; i < brch_size ; i++){
    						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                                <option value='<%=branch.get("BR_ID")%>' <%if(cont_etc.getMng_br_id().equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                                <%	}
    				}
    			         %>			  
    			    <%}%>	
                            </select>	
    			<%}%>	    			  
    			<%if(item_nm.equals("차량이용지역")){%>
    			    <select name='county'>
				<option value=''>구/군</option>
			    </select>   			  			  
                <%}%>	
                      								
    		    </td>			  
    		</tr>		
    		<tr>
    		    <td width="20%" class='title'>변경사유</td>
    		    <td>&nbsp;
    		        <input type='text' name='cng_cau' size='87' class='text' value='<%if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp")){%>채권추심의뢰요청으로 담당자 변경<%}%>' style='IME-MODE: active'></td>			  
    		</tr>		
            </table>
        </td>
    </tr>	  
	  <%if(item_nm.equals("영업담당자") && !base.getCar_st().equals("4")){%>
    <tr> 
        <td><input type='checkbox' name='with_reg' value='Y' checked> 관리담당자에 동일인으로 등록</td>
    </tr>
	  <%}%>
    <tr> 
        <td align="right">
            <%//if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%//}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	  <%}%>
	  <%}%>
	  

	  <%if(vt_size2>1){%>		  
    <tr> 
        <td>* 동일거래처의 영업담당자가 <%=vt_size2%>명 입니다. </td>
    </tr>	
	  <%}%>	  
	  <%if(item_nm.equals("영업담당자") && vt_size2>0){%>		
    <tr> 
        <td align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="5%" class='title'>구분</td>				
                    <td width="8%" class='title'>차량번호 </td>
                    <td width="12%" class='title'>대여기간</td>
                    <td width="7%" class='title'>해지일자</td>					
                    <td width="4%" class='title'>관리<br>지점</td>
                    <td width="8%" class='title'>차량이용지역</td>					
                    <td width="25%" class='title' >지점/현장</td>
                    <td width="25%" class='title' >차량이용자</td>
                    <td width="6%" class='title' >영업<br>담당자</td>			  
                </tr>
				<%	Vector vt3 = a_db.getLcRentClientBusid2List(base.getClient_id());
					int vt_size3 = vt3.size();
    				for (int i = 0 ; i < vt_size3 ; i++){
    					Hashtable ht = (Hashtable)vt3.elementAt(i);%>
                <tr> 
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("RENT_ST")%></td>				
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("CAR_NO")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("RENT_START_DT")%>~<%=ht.get("RENT_END_DT")%></td>									
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("CLS_DT")%></td>					
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("MNG_BR_ID")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("EST_AREA")%> <%=ht.get("COUNTY")%></td>					
                    <td <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("R_SITE")%><br><%=ht.get("ADDR")%></td>
                    <td <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("COM_NM")%> <%=ht.get("MGR_DEPT")%> <%=ht.get("MGR_TITLE")%> <%=ht.get("MGR_NM")%>
					<%if(!String.valueOf(ht.get("MGR_ADDR")).equals("")){%><br>(주소)<%=ht.get("MGR_ADDR")%><%}%>
					<%if(!String.valueOf(ht.get("MGR_EMAIL")).equals("") && !String.valueOf(ht.get("MGR_EMAIL")).equals("@")){%><br>(메일)<%=ht.get("MGR_EMAIL")%><%}%>
					</td>
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("USER_NM")%></td>			  
                </tr>						
				<%	}%>		
            </table>
        </td>
    </tr>	  	
	  <%}%>
    <%if(item_nm.equals("관리구분")){%>	  
    <tr> 
        <td>* 관리구분을 변경하는 경우에 대여요금, 대여요금스케줄, 보험사항-차량관리서비스제공범위도 수정하셔야 합니다.</td>
    </tr>	    
    <%}%>
	  
</table>
<input type='hidden' name="c_st" 		value="<%=c_st%>">	
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
