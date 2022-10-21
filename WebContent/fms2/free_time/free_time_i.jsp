<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.free_time.*,acar.common.*, acar.user_mng.*" %>
<%@ page import="acar.schedule.*, acar.attend.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String title = "";	
	String title1 = "";	
	String sch_file = "";	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//해당부서 사원리스트
	Vector users = new Vector();

	users = c_db.getUserList("", "", "EMP");

	int user_size = users.size();
	
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	//연차사용내역 정보
	Hashtable ht = v_db.getVacation(ck_acar_id);
	double  su = 0;
	
	su = AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT")) ;
				
	st_dt = Util.getDate();
	
	
	Hashtable ht4 = v_db.getVacationBan2(ck_acar_id); //1년내 반차 현황 
	
	int b_su = 0;
	int b1_su = 0;
	int b2_su = 0;
	
	b1_su = AddUtil.parseInt((String)ht4.get("B1"));
	b2_su = AddUtil.parseInt((String)ht4.get("B2"));
	
	b_su =  b1_su - b2_su;	
//	b_su =  Math.abs(b2_su - b1_su);

	
	
%>

<HTML>
<HEAD>
<TITLE>연차등록</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
function free_reg()
{
	var theForm = document.form1;
	 var date = new Date();  
         var day  = date.getDate();  
         var month = date.getMonth() + 1;  
         var year = date.getYear();  
         year = (year < 1000) ? year + 1900 : year;  
	if (("" + month).length == 1) { month = "0" + month; } 
	if (("" + day).length == 1) { day = "0" + day; } 
	var today = year + "-"+ month + "-" + day;
	
	var rr_cnt = 0;	
	
		
	<%if(!ck_acar_id.equals("000096")){%>
		if(theForm.st_dt.value != "2016-05-20"){
			if (theForm.dept_id.value != "0005") {
				if(theForm.st_dt.value < today){
					alert("오늘보다 이전 날짜는 등록할 수 없습니다. 전산팀으로 문의 주세요!!!");
					return;
				}
			}
		}
	<%}%>
	
	if(theForm.user_id.value == ''){	alert("사원을 선택하십시오.");	return;	}
	
	//조민규 제외 ( 000177)  - 20211213
	if ( theForm.user_id.value != '000177' ) {
		if(theForm.title1.value == '오전반휴' || theForm.title1.value == '오후반휴' ){
			if(theForm.st_dt.value != theForm.end_dt.value){
				alert("반휴기간을 확인하세요..!!!");	 
			  	return;		
			}
			// 개발자 김시은 대리, 최진형 대리, 심병호 대리 연차 개수 제한 해제, 추후 투입할 금문일 대리도 추가할 것!
			<%if(nm_db.getWorkAuthUser("외부개발자",ck_acar_id)){}else{%>
		        if(toFloat(theForm.su.value) <  0.5){
				alert("남은연차가 부족하여 반휴를 신청할 수 없습니다!!!");
			  	return;
			}
		    <%}%>
		}
			
		//반차관련 2개이상 차이시 입력체크 - 20211208이후
		if ( <%=Math.abs(b_su)%> >= 2) {		
			//오전반차가 많은 경우 - 오후반차만 등록 또는 연차 
			if ( <%=b_su%> >= 2) {
				if(theForm.title1.value == '오전반휴' ) {
					alert("오전반휴는 등록할 수 없습니다..!!!");	 
				  	return;		
				}
			}	
			
			//오후반차가 많은 경우 -오전반차만 등록 또는 연차
			if ( <%=b_su%> <= -2) {
				if(theForm.title1.value == '오후반휴' ) {
					alert("오후반휴는 등록할 수 없습니다..!!!");	 
				  	return;		
				}
			}			
		}	
	}   //조민규제외

//	if(theForm.user_id.value == ''){	alert("사원을 선택하십시오.");	return;	}
//	if(theForm.sch_chk.value != '8' && theForm.work_id.value == '' || theForm.work_id.value == theForm.user_id.value ){	alert("대체근무자가 본인이거나 선택되지 않았습니다. 대체근무자를 다시 선택하십시오!!");	return;	}
	if(theForm.st_dt.value != "2017-10-02") {
		if(theForm.work_id.value == '' || theForm.work_id.value == theForm.user_id.value ){	alert("대체근무자가 본인이거나 선택되지 않았습니다. 대체근무자를 다시 선택하십시오!!");	return;	}
	}
	if(theForm.title1.value == ''){	alert("중분류를 선택하십시오.");	return;	}
	if(get_length(theForm.content.value) > 4000){alert("4000자 까지만 입력할 수 있습니다."); return; }
	
	var s_str = theForm.end_dt.value;
	var e_str = theForm.st_dt.value;
			
	var s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7), s_str.substring(8,10) );
	var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7), e_str.substring(8,10) );
		
	var diff_date = s_date.getTime() - e_date.getTime();
			
	count = Math.floor(diff_date/(24*60*60*1000));
									
	if ( theForm.sch_chk.value == '3' ) {
		if ( count > 25 ) {  
		  	alert("연차기간을 확인하세요..!!!");	 
		  	return;				
		}
	}	
	
	if ( count < 0 ) {  
	  	alert("연차기간을 확인하세요..!!!");	 
	  	return;				
	}		
	
	if(theForm.title1.value == '시설격리' || theForm.title1.value == '자가격리'  || theForm.title1.value == '백신접종' ){
	 	alert("공가 사용 할 수 없습니다...!!!");	 
	  	return;		
		
	}
		
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.action = "free_time_a.jsp";	
	theForm.submit();
}

function free_close()
{
	var theForm = opener.document.form1;
	theForm.submit();
	self.close();
	window.close();
}

function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

//오늘,내일,모레,글피 설정
function date_type_input(dt_st, date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;
		if(date_type==5){
			fm.st_dt.value = "";
			fm.end_dt.value = "";
		}else{
		if(date_type==2){//내일			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}else if(date_type == 3){
			dt = new Date(today.valueOf()+(24*60*60*1000)*2);						
		}else if(date_type == 4){
			dt = new Date(today.valueOf()+(24*60*60*1000)*3);						
		}
		
		s_dt = String(dt.getFullYear())+"-";
		if(dt.getFullYear()<2000) s_dt = String(dt.getFullYear()+1900)+"-";		
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		
		if(dt_st==1)		fm.st_dt.value = s_dt;		
		else 				fm.end_dt.value = s_dt;				
		}
	}		
	
	
//-->
</script>
<script>
 mArray = new Array("오전반휴","오후반휴","연차");
 aArray = new Array("본인출산","배우자출산","생리휴가","기타"); 
 bArray = new Array("포상휴가"); 
 cArray = new Array("훈련","교육","백신접종","자가격리","시설격리"); 
 dArray = new Array("본인결혼","자녀결혼","부모결혼","형제결혼","부모회갑","부모사망","배우자부모사망","배우자사망","조부모사망","형제/자녀사망","기타"); 
 eArray = new Array("본인출산","배우자출산"); 
 fArray = new Array("본인육아휴직","배우자육아휴직", "기타"); 
 
 function changeSelect(value) {
 	document.all.title.length=1;
  if(value == '3') {
   for(i=0; i<mArray.length; i++) {
    option = new Option(mArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '5') {
   for(i=0; i<aArray.length; i++) {
    option = new Option(aArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '9') {
   for(i=0; i<bArray.length; i++) {
    option = new Option(bArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '7') {
   for(i=0; i<cArray.length; i++) {
    option = new Option(cArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '6') {
   for(i=0; i<dArray.length; i++) {
    option = new Option(dArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '4') {
   for(i=0; i<dArray.length; i++) {
    option = new Option(dArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '8') {
   for(i=0; i<fArray.length; i++) {
    option = new Option(fArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
 }
 
 
function firstChange() {// 대분류 변한 경우
 var x = document.form1.sch_chk.options.selectedIndex;//선택한 인덱스
 var groups=document.form1.sch_chk.options.length;//대분류 갯수
 var group=new Array(groups);//배열 생성
 for (i=0; i<groups; i++) {
  group[i]=new Array();
 }//for
 // 옵션(<option>) 생성
 group[0][0]=new Option("대분류를 먼저 선택하세요","");
 
 group[1][0]=new Option("연차선택","");
 group[1][1]=new Option("오전반휴","오전반휴");//결과 <option value="ss">삼성</option>
 group[1][2]=new Option("오후반휴","오후반휴");
 group[1][3]=new Option("연차","연차");

 group[2][0]=new Option("병가선택","");
 group[2][1]=new Option("본인출산","본인출산");
 group[2][2]=new Option("배우자출산","배우자출산");
 group[2][3]=new Option("생리휴가","생리휴가");
 group[2][4]=new Option("기타","기타");
 
 group[3][0]=new Option("포상휴가선택","");
 group[3][1]=new Option("포상휴가","포상휴가");
  
 group[4][0]=new Option("공가선택","");
 group[4][1]=new Option("훈련","훈련");
 group[4][2]=new Option("교육","교육");
 group[4][3]=new Option("백신접종","백신접종");
 group[4][4]=new Option("자가격리","자가격리");
 group[4][5]=new Option("시설격리","시설격리");
  
 group[5][0]=new Option("경조사선택","");
 group[5][1]=new Option("본인결혼","본인결혼");
 group[5][2]=new Option("자녀결혼","자녀결혼");
 group[5][3]=new Option("부모결혼","부모결혼");
 group[5][4]=new Option("형제결혼","형제결혼");
 group[5][5]=new Option("부모회갑","부모회갑");
 group[5][6]=new Option("부모사망","부모사망");
 group[5][7]=new Option("배우자부모사망","배우자부모사망");
 group[5][8]=new Option("배우자사망","배우자사망");
 group[5][9]=new Option("조부모사망","조부모사망");
 group[5][10]=new Option("형제/자매사망","형제/자매사망");
 group[5][11]=new Option("기타","기타");
 
 group[6][0]=new Option("출산휴가선택","");
 group[6][1]=new Option("본인출산","본인출산");
 group[6][2]=new Option("배우자출산","배우자출산");

 group[7][0]=new Option("휴직선택","");
 group[7][1]=new Option("본인육아휴직","본인육아휴직");
 group[7][2]=new Option("배우자육아휴직","배우자육아휴직");
 group[7][3]=new Option("기타","기타");


 temp = document.form1.title1;//두번 째 셀렉트 얻기(<select name=second>)
 for (m = temp.options.length - 1 ; m > 0 ; m--) {//현재 값 지우기
  temp.options[m]=null
 }
 for (i=0;i<group[x].length;i++){//값 셋팅
  //예) <option value="ss">삼성</option>
  temp.options[i]=new Option(group[x][i].text,group[x][i].value);
 }
 temp.options[0].selected=true//인덱스 0번째, 즉, 첫번째 선택
}//firstChange

 //대체근무자 조회하기
	function User_search(dept_id)
	{
		var fm = document.form1;
		if(fm.user_id.value == ''){		alert("사원명을 선택하십시오.");	return;	}
		if(fm.sch_chk.value == ''){		alert("대분류를 선택하십시오.");	return;	}
		if(fm.title1.value == ''){		alert("중분류를 선택하십시오.");	return;	}
		if(fm.st_dt.value == ''){		alert("휴가기간을 입력하십시오.");	return;	}
		if(fm.end_dt.value == ''){		alert("휴가기간을 입력하십시오.");	return;	}
		var st_dt = fm.st_dt.value;
		var end_dt = fm.end_dt.value;
		var user_id = fm.user_id.value;
		var title1 = fm.title1.value;
		var dept_id = dept_id;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=500,height=700,left=370,top=200');		
		fm.action = "user_search.jsp?st_dt="+st_dt+"&end_dt="+end_dt+"&dept_id="+dept_id+"&user_id="+user_id+"&title1="+title1;
		fm.target = "User_search";
		fm.submit();		
	}
 
 
</script>
 

</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>휴가신청 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="" name='form1' method='post'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='go_url' value='<%=go_url%>'>
	<tr>
		<td align='right'>
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	 		<a href="javascript:free_reg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
		<%}%>
			<a href="javascript:free_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>사원명</td>
                    <td align='left' >&nbsp; 
                      <select name="user_id">
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); 
								if(ck_acar_id.equals(user.get("USER_ID"))){
									dept_id = String.valueOf(user.get("DEPT_ID"));
								}
								%>
								
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
						
                        <%	}
        				}		%>
                      </select><!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사용가능 연차수 :  <%=su%>일 -->
                    </td>
                    <td width="45%" align='left' >&nbsp;* 반휴가 현황 &nbsp;&nbsp;&nbsp;&nbsp;오전 :&nbsp;<%=b1_su%>&nbsp;&nbsp;&nbsp;&nbsp;오후:&nbsp;<%=b2_su%> </td>
                    
				</tr>
                <tr> 
                    <td width='15%' class='title'>휴가구분</td>
                    <td width="40%" align='left' >&nbsp; 
						<select name='sch_chk' onchange="firstChange();" size=1>
							<option value=''>대분류선택</option>
							<option value='3'>연차</option>
							<option value='5'>병가</option>
							<option value='9'>포상휴가</option>
							<option value='7'>공가</option>
							<option value='6'>경조사</option>
							<option value='4'>출산휴가</option>
							<option value='8'>휴직</option>
						</select>
	                      &nbsp;
						<select name='title1' size=1>
	 						<option value=''>중분류선택</option>
						</select>
					</td>
                    <td width="45%" align='left' >&nbsp;- 훈련은 공가로 선택, 코로나백신접종은 공가로 선택
                   <br>&nbsp;- 포상휴가는 장기근속사원 해당자인 경우만 선택
					<br>&nbsp;- 오전반휴 09시~13시까지, 오후반휴 13시부터
					</td>
                </tr>
				<tr> 
                    <td class='title'>휴가기간</td>
                    <td colspan="2">&nbsp; 
						<input type="text" name="st_dt" value='<%=st_dt%>' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
						시작일선택  
						<label><input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(1,1)"checked>오늘</label>
						<label><input type='radio' name="date_type1" value='2' onClick="javascript:date_type_input(1,2)">내일</label>
						<label><input type='radio' name="date_type1" value='3' onClick="javascript:date_type_input(1,3)">모레</label>
						<label><input type='radio' name="date_type1" value='4' onClick="javascript:date_type_input(1,4)">글피</label>
						<label><input type='radio' name="date_type1" value='5' onClick="javascript:date_type_input(1,5)">직접입력</label>
						<br/>
						&nbsp; 
						<input type="text" name="end_dt" value='' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
						종료일선택 
						<label><input type='radio' name="date_type2" value='1' onClick="javascript:date_type_input(2,1)"checked>오늘</label>
						<label><input type='radio' name="date_type2" value='2' onClick="javascript:date_type_input(2,2)">내일</label>
						<label><input type='radio' name="date_type2" value='3' onClick="javascript:date_type_input(2,3)">모레</label>
						<label><input type='radio' name="date_type2" value='4' onClick="javascript:date_type_input(2,4)">글피</label>
						<label><input type='radio' name="date_type2" value='5' onClick="javascript:date_type_input(2,5)">직접입력</label>
                    </td>
                </tr>				
				<tr> 
                    <td class='title'>대체업무자</td>
                    <td colspan="2" align='left' >&nbsp; 
                      <input ytpe="text" name="user_nm" size="11" class=text readOnly>
					  <input type="hidden" name="work_id" >  <a href="javascript:User_search('<%=dept_id%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
        			  &nbsp; - 연차,휴가,병가,경조사일때 : 전자문서 결재 대체자 검색
                    </td>
                </tr>
                
                <tr> 
                    <td class='title'>첨부(증빙)</td>
                    <td colspan="2" >&nbsp; 
                      첨부파일은 연차등록 후 상세화면에서 등록하시기 바랍니다.
                    </td>
                </tr>
                <tr> 
                    <td class='title'>내용</td>
                    <td colspan="2" >&nbsp; 
                      <textarea name='content' rows='7' cols='70' ></textarea>
                    </td>
                </tr>
            </table>
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type="hidden" name="su" value="<%=su%>">		
			<input type="hidden" name="dept_id" value="<%=dept_id%>">
			<input type="hidden" name="cmd" value="">	
			<input type='hidden' name="s_width" value="<%=s_width%>">   
			<input type='hidden' name="s_height" value="<%=s_height%>">  
			<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  	
			
		</td>
	</tr>	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
