<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_reg.*"%>
<%@ page import="acar.car_register.*" %>
<jsp:useBean id="cm_bean" class="acar.car_register.CarMaintBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id"); 
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "01", "01");	
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");	
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String mdata = request.getParameter("mdata")==null?"":request.getParameter("mdata");
	
	//정기검사	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cm_bean = crd.getCarMaint(car_mng_id,seq_no);
	
	if(!car_mng_id.equals(""))	cr_bean = crd.getCarRegBean(car_mng_id);
			
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	String ch_m_dt = "";
	String ch_m_km = "";
	String ch_m_amt = "";
	String ch_m_comp = "";
	
	if ( !mdata.equals("") ) {
		StringTokenizer token1 = new StringTokenizer(mdata,"^");
					
		while(token1.hasMoreTokens()) {
					ch_m_comp = token1.nextToken().trim();	
					ch_m_dt = token1.nextToken().trim();	 
					ch_m_km = token1.nextToken().trim();	 
					ch_m_amt = token1.nextToken().trim();
		}			
	}
	
	String r_che_dt = "";
	r_che_dt = cm_bean.getChe_dt();
	if (r_che_dt.equals("") ){
		r_che_dt = ch_m_dt; 
          }
		
	String r_che_comp = "";
	r_che_comp =cm_bean.getChe_comp();
	if (r_che_comp.equals("") ){
		r_che_comp = ch_m_comp;
          }

	int r_che_amt = 0;
	r_che_amt =cm_bean.getChe_amt();
	if (r_che_amt == 0 ) {
		r_che_amt = AddUtil.parseInt(ch_m_amt);
         }
        
         int r_che_km = 0;
	r_che_km =cm_bean.getChe_km();
	if (r_che_km == 0  ) {
   	    r_che_km = AddUtil.parseInt(ch_m_km);
   }    
	       
	
    
    //5년이상
   String r_y5_dt = "";
   r_y5_dt = crd.getR_year5_dt(cr_bean.getInit_reg_dt());   
 //  out.println(r_y5_dt); 
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function init(){
	var fm = document.form1;
	fm.seq_no.value = '';
	fm.action = 'cus_reg_maint_in.jsp';
	fm.target = 'maint_in';
	fm.submit();
}

function upMaint(gubun){

	var fm = document.form1;
	
//	chk_maint();
			
//          alert(getToday());
   
	// 승용제외한 차량, 소형 승합.화물 제외 
           			
	if (fm.car_kd.value == "1" || fm.car_kd.value == "2" || fm.car_kd.value == "3" || fm.car_kd.value == "9" ) { //소형, 중형, 대형 승용
		if(getRentTime('m', fm.maint_st_dt.value, fm.maint_end_dt.value) < 12){ 
		//       alert(fm.car_kd.value));
		//       alert(getRentTime('m', fm.maint_st_dt.value, fm.maint_end_dt.value));
			alert('다음 유효기간의 날짜를 확인하십시오.');
			return;
		}
	} else {
		if (  fm.car_use.value == "2" &&( fm.car_kd.value == "4" || fm.car_kd.value == "5" ||  fm.car_kd.value == "6" ||  fm.car_kd.value == "7" ||  fm.car_kd.value == "8") && fm.r_5y_dt.value < getToday()  ) { //리스이고, 승합이나 화물인 경우, 5년 이상부터 6개월마다 검사
			if(getRentTime('m', fm.maint_st_dt.value, fm.maint_end_dt.value) < 6){ 
				//alert(getRentTime('m', fm.maint_st_dt.value, fm.maint_end_dt.value));
				alert('다음 유효기간의 날짜를 확인하십시오.(6)');
				return;
			}
	        }
	
	}	
	
	if(fm.che_st_dt.value==""){		alert("검사유효기간 시작일을 입력해 주세요!");	fm.che_st_dt.focus(); return; }	
  	if (!checkDate('검사유효기간 시작일', replaceString("-","",fm.che_st_dt.value))){	alert("검사유효기간 시작일 확인해 주세요!");	fm.che_st_dt.focus(); return; }
	if(fm.che_end_dt.value==""){	alert("검사유효기간 종료일을 입력해 주세요!");	fm.che_end_dt.focus(); return; }
	if (!checkDate('검사유효기간 종료일', replaceString("-","",fm.che_end_dt.value))){	alert("검사유효기간 종료일 확인해 주세요!");	fm.che_end_dt.focus(); return; }
	if(fm.che_dt.value==""){		alert("점검일자를 입력해 주세요!");	fm.che_dt.focus(); return; }
	if (!checkDate('점검일자', replaceString("-","",fm.che_dt.value))){	alert("점검일자를 확인해 주세요!");	fm.che_dt.focus(); return; }
	if(fm.che_kd.value==""){		alert("점검종별을 선택해 주세요!");	fm.che_kd.focus(); return; }
	if(fm.che_comp.value==""){		alert("검사소를 입력해 주세요!");	fm.che_comp.focus(); return; }
	if(toInt(fm.che_amt.value)<=0){		alert("비용을 입력해 주세요!");		fm.che_amt.focus(); return; }
	if(toInt(fm.che_km.value)<=0){		alert("주행거리를 입력해 주세요!");	fm.che_km.focus(); return; }
	if(fm.che_no.value==""){		alert("담당자를 선택해 주세요!");	fm.che_no.focus(); return; }
	if(fm.maint_st_dt.value==""){	alert("다음검사(점검)유효기간 시작일을 입력해 주세요!");	fm.maint_st_dt.focus(); return; }
	if (!checkDate('다음검사(점검)유효기간 시작일', replaceString("-","",fm.maint_st_dt.value))){	alert("다음검사(점검)유효기간 시작일을 확인해 주세요!");	fm.maint_st_dt.focus(); return; }
	if(fm.maint_end_dt.value==""){	alert("다음검사(점검)유효기간 종료일을 입력해 주세요!");	fm.maint_end_dt.focus(); return; }
 	if (!checkDate('다음검사(점검)유효기간 종료일', replaceString("-","",fm.maint_end_dt.value))){	alert("다음검사(점검)유효기간 종료일을 확인해 주세요!");	fm.maint_end_dt.focus(); return; }
   	
   	//검사유효기간
	chk_maint();
		
	//점검유효기간
//	chk_test();		
   	
   	
	if(gubun=="i"){
		if(!confirm('등록 하시겠습니까?')){ return; }
	}else if(gubun=="u"){
		if(!confirm('수정 하시겠습니까?')){ return; }
	}
	
	var link = document.getElementById("submitLink");
	var originFunc = link.getAttribute("href");
	link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
	fm.gubun.value = gubun;
	fm.action = 'maint_iu.jsp';
	fm.target = 'i_no';
	fm.submit();
	
	link.getAttribute('href',originFunc);
}

	//대여일수 구하기
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}	
	
	
	//점검유효기간
function chk_test() { 
   		
	var  car_use = document.form1.car_use.value;
	var  car_kd= document.form1.car_kd.value;
	var	test_st = document.form1.maint_st_dt.value;
	var	test_ed = document.form1.maint_end_dt.value;	
	var	test_st_dt;   // 계산값
	var	test_end_dt; //계산값	
	var  che_kd= document.form1.che_kd.value;
	
	if ( che_kd == '3'  && car_use == '1'   ) {  //점검이고 렌트이면
												
		test_st_dt =replaceString("-","", document.form1.che_st_dt.value); //점검유효기간 시작일
		test_end_dt =replaceString("-","", document.form1.che_end_dt.value); //점검유효기간 만기일
								
		var s1_date =  new Date (test_st_dt.substring(0,4), test_st_dt.substring(4,6) -1 , test_st_dt.substring(6,8) );
		var e1_date =  new Date (test_end_dt.substring(0,4), test_end_dt.substring(4,6) -1 , test_end_dt.substring(6,8) );
		var DDyear  = s1_date.getYear()+1;
		var DDyear2  = e1_date.getYear()+1;
						
		var ntest_st_dt = DDyear  + test_st_dt.substring(4,6) +  test_st_dt.substring(6,8); //검사유효기간 종료일
		var ntest_end_dt = DDyear2  + test_end_dt.substring(4,6) +  test_end_dt.substring(6,8); //검사유효기간 종료일
						
		//검사일
	//	if( ntest_st_dt  !=  replaceString("-","",test_st) ){
	//		if(confirm('입력한 점검유효기간과 계산된값(시작일)이 차이가 있습니다. 점검유효기간 확인후  맞다면 계속 진행하셔도 됩니다.!!')){	
	//		}
	//	}
							
		if( ntest_end_dt  !=  replaceString("-","",test_ed) ){
			if(confirm('입력한 점검유효기간과 계산된값(종료일)이 차이가 있습니다.  점검유효기간 확인후  맞다면 계속 진행하셔도 됩니다.!!')){	
			}
		}				
	   
	}
		
}

//검사유효기간
function chk_maint() { 

	var NowDay = new Date();
			
	var  car_use = document.form1.car_use.value;    //1:업무용
	var  car_kd= document.form1.car_kd.value;  
	var	maint_st = document.form1.maint_st_dt.value;
	var	maint_ed = document.form1.maint_end_dt.value;	
	var	maint_st_dt;    //계산값
	var	maint_end_dt;    //계산값
		
	maint_st_dt =replaceString("-","", document.form1.che_st_dt.value); //검사유효기간 시작일 (현재)
	maint_end_dt =replaceString("-","", document.form1.che_end_dt.value); //검사유효기간 만기일(현재)
				
	 if(car_use == 2 && (car_kd == 1 || car_kd == 2 || car_kd == 3 || car_kd == 9) ){//리스 , 승용만 2년 주기 기타는 1년주기 ( 승합. 화물은 5년후 6개월주기)
	
			var s1_date =  new Date (maint_st_dt.substring(0,4), maint_st_dt.substring(4,6) -1 , maint_st_dt.substring(6,8) );
			var e1_date =  new Date (maint_end_dt.substring(0,4), maint_end_dt.substring(4,6) -1 , maint_end_dt.substring(6,8) );
			var DDyear  = s1_date.getFullYear()+2;
			var DDyear2  = e1_date.getFullYear()+2;
			
		//		      alert("1");
		//	     alert(DDyear2);
							
			var nmaint_st_dt = DDyear  + maint_st_dt.substring(4,6) +  maint_st_dt.substring(6,8); //검사유효기간 종료일
			var nmaint_end_dt = DDyear2  + maint_end_dt.substring(4,6) +  maint_end_dt.substring(6,8); //검사유효기간 종료일
							
			//검사일
		//	if( nmaint_st_dt  !=  replaceString("-","",maint_st) ){
		//		if(confirm('입력한 검사유효기간과 계산된값(시작일)이 차이가 있습니다. 검사유효기간 확인후  맞다면 계속 진행하셔도 됩니다.!!')){	
		//		}
		//	}
								
			if( nmaint_end_dt  !=  replaceString("-","",maint_ed) ){
				if(confirm('입력한 검사유효기간과 계산된값(종료일)이 차이가 있습니다.  검사유효기간 확인후  맞다면 계속 진행하셔도 됩니다.!!')){	
				}
			}	

	} else { 
	       if     ( document.form1.r_5y_dt.value < getToday() ) {   //5년경과&& 승합,화물인경우 
	       	  if (   car_kd == 4 || car_kd == 7 || car_kd == 8 )  {
	       		
	       		var e1_date =  new Date (maint_end_dt.substring(0,4), maint_end_dt.substring(4,6) -1 , maint_end_dt.substring(6,8) );
			
			//    alert(new Date(Date.parse(new Date())  + 180 * 1000 * 60 * 60 * 24)); //6개월후       
			
			var e2_date = new Date(Date.parse(e1_date)  + 180 * 1000 * 60 * 60 * 24);
	
			var year1 = e2_date.toString().substring(28);
						
			var month1 =e2_date.getMonth() + 1;
					
			var day1 = e2_date.getDate();
				
			if(month1 < 10) month1="0"+month1;
			if(day1 < 10) day1="0"+day1;
			var nmaint_end_dt = year1+month1+day1; //검사유효기간 종료일
			
		//	alert(nmaint_end_dt);
			
			//	      alert("2");
			 
			     												
			if( nmaint_end_dt  !=  replaceString("-","",maint_ed) ){
				if(confirm('입력한 검사유효기간과 계산된값(종료일)이 차이가 있습니다.  검사유효기간 확인후  맞다면 계속 진행하셔도 됩니다.!!')){	
				}
			}	
		   } else {
		  	var s1_date =  new Date (maint_st_dt.substring(0,4), maint_st_dt.substring(4,6) -1 , maint_st_dt.substring(6,8) );
			var e1_date =  new Date (maint_end_dt.substring(0,4), maint_end_dt.substring(4,6) -1 , maint_end_dt.substring(6,8) );
			var DDyear  = s1_date.getFullYear()+1;
			var DDyear2  = e1_date.getFullYear()+1;
			
		//	      alert("3");
		//	     alert(DDyear2);
			     				
			var nmaint_st_dt = DDyear  + maint_st_dt.substring(4,6) +  maint_st_dt.substring(6,8); //검사유효기간 종료일
			var nmaint_end_dt = DDyear2  + maint_end_dt.substring(4,6) +  maint_end_dt.substring(6,8); //검사유효기간 종료일
									
			if( nmaint_end_dt  !=  replaceString("-","",maint_ed) ){
				if(confirm('입력한 검사유효기간과 계산된값(종료일)이 차이가 있습니다.  검사유효기간 확인후  맞다면 계속 진행하셔도 됩니다.!!')){	
				}
			}
		}	
	            
	       } else {	//5년경과가 안된 경우
			var s1_date =  new Date (maint_st_dt.substring(0,4), maint_st_dt.substring(4,6) -1 , maint_st_dt.substring(6,8) );
			var e1_date =  new Date (maint_end_dt.substring(0,4), maint_end_dt.substring(4,6) -1 , maint_end_dt.substring(6,8) );
			var DDyear  = s1_date.getFullYear()+1;
			var DDyear2  = e1_date.getFullYear()+1;
			
		//		      alert("4");
		//	     alert(DDyear2);
			     				
			var nmaint_st_dt = DDyear  + maint_st_dt.substring(4,6) +  maint_st_dt.substring(6,8); //검사유효기간 종료일
			var nmaint_end_dt = DDyear2  + maint_end_dt.substring(4,6) +  maint_end_dt.substring(6,8); //검사유효기간 종료일
			
		//	  alert(nmaint_end_dt);	
									
			if( nmaint_end_dt  !=  replaceString("-","",maint_ed) ){
				if(confirm('입력한 검사유효기간과 계산된값(종료일)이 차이가 있습니다.  검사유효기간 확인후  맞다면 계속 진행하셔도 됩니다.!!')){	
				}
			}
		}		
	
	}
	
}

		
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="client_id" value="<%= client_id %>">
<input type="hidden" name="car_use" value="<%= cr_bean.getCar_use() %>">
<input type="hidden" name="car_kd" value="<%= cr_bean.getCar_kd() %>">
<input type="hidden" name="r_5y_dt" value="<%=r_y5_dt%>">
<input type="hidden" name="seq_no" value="<%= seq_no %>">
<input type="hidden" name="go_url" value="<%= go_url %>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=16%>검사(점검)유효기간</td>
                    <td class='left' width=23%>&nbsp; <input type="text" name="che_st_dt" size="11" class=text value="<%= cm_bean.getChe_st_dt() %>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="che_end_dt" size="11" class=text value="<%= cm_bean.getChe_end_dt() %>" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                    <td class='title' width=13%>점검일자</td>
                    <td class='left' width=17%>&nbsp; <input type="text" name="che_dt" size="11" class=text value="<%= r_che_dt %>" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                    <td class='title'width=13%>점검종별</td>
                    <td class='left' width=17%>&nbsp; <select name="che_kd">
                        <option value="1" <% if(cm_bean.getChe_kd().equals("1"))	out.print("selected"); %>>정기검사</option>
                        <option value="2" <% if(cm_bean.getChe_kd().equals("2"))	out.print("selected"); %>>정기정밀검사</option>
    <!--    				<option value="3" <% if(cm_bean.getChe_kd().equals("3"))	out.print("selected"); %>>정기점검</option> -->
                      </select> </td>
                </tr>
                <tr> 
                    <td class='title'>검사소</td>
                    <td class='left'>&nbsp; <input type="text" name="che_comp" size="20" class=text value="<%= r_che_comp %>"> 
                    </td>
                    <td class='title'>비용</td>
                    <td class='left'>&nbsp; <input type="text" name="che_amt" size="10" class=num value="<%= AddUtil.parseDecimal(r_che_amt) %>" onBlur="javascript:this.value=parseDecimal(this.value);">
                      원</td>
                    <td class='title'>주행거리</td>
                    <td class='left'>&nbsp; <input type="text" name="che_km" size="10" class=num value="<%= AddUtil.parseDecimal(r_che_km) %>" onBlur="javascript:this.value=parseDecimal(this.value);">
                      km 
					  </td>
                </tr>
                <tr> 
                    <td class='title'>담당자</td>
                    <td colspan="5" class='left'>&nbsp; 
                      <select name='che_no'>
        	              <%if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        					%>
        	          				  <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
        	                <%	}
        					}		%>
        				</select>  
        	              
                        <input type="text" name="che_no_s" size="16" class=text disabled value="<%if(!cm_bean.getChe_no().equals("")&&(!cm_bean.getChe_no().substring(0,2).equals("00"))) out.print(cm_bean.getChe_no()); %>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>다음검사(점검)유효기간</td>
                    <td colspan="5" class='left'> &nbsp; <input type="text" name="maint_st_dt" size="11" class=text value="" onBlur="javascript:this.value=ChangeDate(this.value);">
                      ~ 
                      <input type="text" name="maint_end_dt" size="11" class=text value="" onBlur="javascript:this.value=ChangeDate(this.value);">
                     <font color=blue>&nbsp;* 반드시 입력하세요.</font>
                    </td>
                </tr>
                 <tr> 
                    <td class='title'>비고</td>
                    <td colspan="5" class='left'> &nbsp; <textarea name='che_remark' rows='2' cols='140'></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
     <tr>
        <td>       
              &nbsp;&nbsp;&nbsp;<font color=red>*화물, 승합차량은 차령이 5년초과된 경우  6개월단위 정기검사를 받아야 합니다.  반드시 날짜 확인하셔서 입력하셔야 합니다. </font>
       	 
        </td>
    </tr>
    <tr> 
        <td align="right"> 
	      <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
        <% if(seq_no.equals("")){ %>
		  	<a id="submitLink" href="javascript:upMaint('i')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
		    <% }else{ %>
        <a href='javascript:init()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_init.gif align=absmiddle border=0></a> 
        <a id="submitLink" href="javascript:upMaint('u')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a> 
        <% } %>
        <%} %>
		</td>		
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
