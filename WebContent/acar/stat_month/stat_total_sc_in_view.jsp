<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_bus.*, acar.stat_total.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.stat_total.StatTotalDatabase"/>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"6":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"total":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");			
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String dept_id = "";
	String gubun_dt = "";
	
	if(save_dt.equals(""))	save_dt = st_db.getMaxSaveDt("stat_total");
	if(save_dt.equals(""))	gubun_dt = st_db.getMaxSaveDt("stat_mng");
	
	Vector totals1 = new Vector();
	Vector totals2 = new Vector();
	Vector totals3 = new Vector();
	Vector totals4 = new Vector();
	Vector totals5 = new Vector();
	Vector totals = new Vector();
	
	int total_size1 = 0;
	int total_size2 = 0;
	int total_size3 = 0;
	int total_size4 = 0;
	int total_size5 = 0;
	int total_size = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(save_dt.equals(""))	gubun_dt = st_db.getMaxSaveDt("stat_mng");

	//가중치 부여(기본)
	String d1 = "10";
	String d2 = "2";
	String m1 = "1";
		
	CodeBean[] depts = c_db.getCodeAll2("0002", ""); /* 코드 구분:부서명-가산점적용 */
	int dept_size = depts.length;
	CodeBean[] ways = c_db.getCodeAll2("0005", "Y"); /* 코드 구분:대여방식-가산점적용 */
	int way_size = ways.length;
	
	
	for(int i = 0 ; i < dept_size ; i++){
		CodeBean dept = depts[i];
		
		d1 = am_db.getMarks("S1", "", "11",  "0", "0003", "4");
		d2 = am_db.getMarks("S1", "", "12",  "0", "0003", "4");
		m1 = am_db.getMarks("S1", "", "13",  "0", "0003", "4");
		
		
	}
	
	
	totals =  st_db.getStatTotalAvg(brch_id, "all", s_yy, s_mm, d1, d2, m1);
	total_size = totals.size();
		
	float htot_ga[] 	= new float[3];
	float hm_ga[] 	= new float[3];
	float hd_ga[] 	= new float[3];
	float hb_ga[] 	= new float[3];
	float hd_per[] 	= new float[3];
		
	String b_nm ="";
	int  b_cnt = 0;
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
-->
</script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
	return;	
		var fm = document.form1;	
		if(fm.save_dt.value != ''){ alert("이미 마감 등록된 사원별 관리현황입니다."); return; }
		if(!confirm('마감하시겠습니까?'))
			return;
		fm.target='i_no';
		fm.action='stat_total_sc_null.jsp';
		fm.submit();		
	}	
	
	//일별통계
	function stat_search(mode, bus_id2){
		var fm = document.form1;	
		fm.mode.value = mode;
		fm.bus_id2.value = bus_id2;
		fm.action = 'stat_case_sh.jsp';
		fm.target='d_content';
		fm.submit();		
	}		

	//처음 셋팅하기
	function set_sum(){
		var fm = document.form1;	
		var size1 = toInt(fm.total_size1.value);
		var size2 = toInt(fm.total_size2.value);
		var size3 = toInt(fm.total_size3.value);
		var size4 = toInt(fm.total_size4.value);
		var size5 = toInt(fm.total_size5.value);				
		var t_size1 = size1+size2+size4+size5;
		var t_size2 = size1+size2+size3+size4+size5;

		//총평점	
		for(i=0; i<t_size1 ; i++){					
//			fm.tot_ga[i].value	= toFloat(fm.m_ga[i].value) + (( <%=d1%> - toFloat(fm.d_ga[i].value)) * <%=d2%>) ;
			fm.tot_ga[i].value	= toFloat(fm.m_ga[i].value) + toFloat(fm.d_ga[i].value) ;			
			fm.tot_ga[i].value  = parseFloatCipher3(fm.tot_ga[i].value, 2);
		}		

		//고객지원팀 소계
		for(i=0; i<size1; i++){				
			fm.htot_ga[0].value	= toFloat(fm.htot_ga[0].value) + toFloat(fm.tot_ga[i].value);
			fm.hm_ga[0].value	= toFloat(fm.hm_ga[0].value) + toFloat(fm.m_ga[i].value);
			fm.hd_ga[0].value	= toFloat(fm.hd_ga[0].value) + toFloat(fm.d_ga[i].value);
			fm.hb_ga[0].value	= toFloat(fm.hb_ga[0].value) + toFloat(fm.b_ga[i].value);
			fm.hd_per[0].value	= toFloat(fm.hd_per[0].value) + toFloat(fm.d_per[i].value);
		}
		fm.htot_ga[0].value = parseFloatCipher3(toFloat(fm.htot_ga[0].value)/size1, 2);
		fm.hm_ga[0].value 	= parseFloatCipher3(toFloat(fm.hm_ga[0].value)/size1, 2);
		fm.hd_ga[0].value 	= parseFloatCipher3(toFloat(fm.hd_ga[0].value)/size1, 2);				
		fm.hb_ga[0].value 	= parseFloatCipher3(toFloat(fm.hb_ga[0].value)/size1, 2);						
		fm.hd_per[0].value 	= parseFloatCipher3(toFloat(fm.hd_per[0].value)/size1, 2);

		//영업팀 소계
		for(i=size1; i<size1+size2; i++){	
			fm.htot_ga[1].value	= toFloat(fm.htot_ga[1].value) + toFloat(fm.tot_ga[i].value);
			fm.hm_ga[1].value	= toFloat(fm.hm_ga[1].value) + toFloat(fm.m_ga[i].value);
			fm.hd_ga[1].value	= toFloat(fm.hd_ga[1].value) + toFloat(fm.d_ga[i].value);
			fm.hb_ga[1].value	= toFloat(fm.hb_ga[1].value) + toFloat(fm.b_ga[i].value);
			fm.hd_per[1].value	= toFloat(fm.hd_per[1].value) + toFloat(fm.d_per[i].value);
		}
		fm.htot_ga[1].value = parseFloatCipher3(toFloat(fm.htot_ga[1].value)/size2, 2);
		fm.hm_ga[1].value 	= parseFloatCipher3(toFloat(fm.hm_ga[1].value)/size2, 2);
		fm.hd_ga[1].value 	= parseFloatCipher3(toFloat(fm.hd_ga[1].value)/size2, 2);				
		fm.hb_ga[1].value 	= parseFloatCipher3(toFloat(fm.hb_ga[1].value)/size2, 2);						
		fm.hd_per[1].value 	= parseFloatCipher3(toFloat(fm.hd_per[1].value)/size2, 2);
		
		//부산지점 소계
		for(i=size1+size2+size3; i<size1+size2+size3+size4; i++){	
			fm.htot_ga[2].value	= toFloat(fm.htot_ga[2].value) + toFloat(fm.tot_ga[i].value);
			fm.hm_ga[2].value	= toFloat(fm.hm_ga[2].value) + toFloat(fm.m_ga[i].value);
			fm.hd_ga[2].value	= toFloat(fm.hd_ga[2].value) + toFloat(fm.d_ga[i].value);
			fm.hb_ga[2].value	= toFloat(fm.hb_ga[2].value) + toFloat(fm.b_ga[i].value);
			fm.hd_per[2].value	= toFloat(fm.hd_per[2].value) + toFloat(fm.d_per[i].value);
		}
		fm.htot_ga[2].value = parseFloatCipher3(toFloat(fm.htot_ga[2].value)/size4, 2);
		fm.hm_ga[2].value 	= parseFloatCipher3(toFloat(fm.hm_ga[2].value)/size4, 2);
		fm.hd_ga[2].value 	= parseFloatCipher3(toFloat(fm.hd_ga[2].value)/size4, 2);				
		fm.hb_ga[2].value 	= parseFloatCipher3(toFloat(fm.hb_ga[2].value)/size4, 2);						
		fm.hd_per[2].value 	= parseFloatCipher3(toFloat(fm.hd_per[2].value)/size4, 2);
		
		//대전지점 소계
		for(i=size1+size2+size3+size4; i<size1+size2+size3+size4+size5; i++){	
			fm.htot_ga[3].value	= toFloat(fm.htot_ga[3].value) + toFloat(fm.tot_ga[i].value);
			fm.hm_ga[3].value	= toFloat(fm.hm_ga[3].value) + toFloat(fm.m_ga[i].value);
			fm.hd_ga[3].value	= toFloat(fm.hd_ga[3].value) + toFloat(fm.d_ga[i].value);
			fm.hb_ga[3].value	= toFloat(fm.hb_ga[3].value) + toFloat(fm.b_ga[i].value);
			fm.hd_per[3].value	= toFloat(fm.hd_per[3].value) + toFloat(fm.d_per[i].value);
		}
		fm.htot_ga[3].value = parseFloatCipher3(toFloat(fm.htot_ga[3].value)/size5, 2);
		fm.hm_ga[3].value 	= parseFloatCipher3(toFloat(fm.hm_ga[3].value)/size5, 2);
		fm.hd_ga[3].value 	= parseFloatCipher3(toFloat(fm.hd_ga[3].value)/size5, 2);				
		fm.hb_ga[3].value 	= parseFloatCipher3(toFloat(fm.hb_ga[3].value)/size5, 2);						
		fm.hd_per[3].value 	= parseFloatCipher3(toFloat(fm.hd_per[3].value)/size5, 2);
		
		//총계
		for(i=0; i<size1+size2+size3+size4+size5 ; i++){
			fm.htot_ga[4].value	= toFloat(fm.htot_ga[4].value) + toFloat(fm.tot_ga[i].value);
			fm.hm_ga[4].value	= toFloat(fm.hm_ga[4].value) + toFloat(fm.m_ga[i].value);
			fm.hd_ga[4].value	= toFloat(fm.hd_ga[4].value) + toFloat(fm.d_ga[i].value);
			fm.hb_ga[4].value	= toFloat(fm.hb_ga[4].value) + toFloat(fm.b_ga[i].value);
			fm.hd_per[4].value	= toFloat(fm.hd_per[4].value) + toFloat(fm.d_per[i].value);
		}		
		fm.htot_ga[4].value = parseFloatCipher3(toFloat(fm.htot_ga[4].value)/t_size1, 2);
		fm.hm_ga[4].value 	= parseFloatCipher3(toFloat(fm.hm_ga[4].value)/t_size1, 2);
		fm.hd_ga[4].value 	= parseFloatCipher3(toFloat(fm.hd_ga[4].value)/t_size1, 2);				
		fm.hb_ga[4].value 	= parseFloatCipher3(toFloat(fm.hb_ga[4].value)/t_size1, 2);						
		fm.hd_per[4].value 	= parseFloatCipher3(toFloat(fm.hd_per[4].value)/t_size1, 2);
	}	

	//세부리스트 이동
	function move_list(dept_id, user_id, mng_way, mng_st){	
	return;	
		var fm = document.form1;
		fm.s_dept.value = dept_id;
		fm.s_user.value = user_id;		
		fm.s_mng_way.value = mng_way;
		fm.s_mng_st.value = mng_st;
		if(mng_way == '0'){
			fm.action = "stat_bus_client_frame_s.jsp?";
		}else{
			fm.action = "stat_bus_car_frame_s.jsp";
		}
		fm.target='d_content';
		fm.submit();		
	}
-->
</script>
<!--<link rel=stylesheet type="text/css" href="../../include/table.css">-->
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form action="stat_bus_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='gubun_dt' value='<%=gubun_dt%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='total_size1' value='<%=total_size1%>'>
<input type='hidden' name='total_size2' value='<%=total_size2%>'>
<input type='hidden' name='total_size3' value='<%=total_size3%>'>
<input type='hidden' name='total_size4' value='<%=total_size4%>'>
<input type='hidden' name='total_size5' value='<%=total_size5%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='d1' value='<%=d1%>'>
<input type='hidden' name='d2' value='<%=d2%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class=line width='40%' id='td_title' style='position:relative;'>	
       <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width="25%">부서</td>
                    <td class=title width="10%" style='height:51'>연번</td>
                    <td class=title width="30%">성명</td>
                    <td class=title width="35%">입사일자</td>            
                </tr>
            </table>
	    </td>
	    <td width='60%' class=line>
	        <table width='100%' border="0" cellspacing="1" cellpadding="0">
                <tr> 
                   <td class=title width="20%"  rowspan="2">평점<br>
                      (관리+연체)</td>
                    <td class=title width="20%" rowspan="2">관리</td>
                    <td class=title colspan="2">연체</td>
                    <td class=title width="20%" rowspan="2">영업</td>
                </tr>
                <tr> 
                    <td class=title width="20%">평점</td>
                    <td class=title width="20%">연체율</td>
                </tr>
            </table>
	    </td>
    </tr>  			  
    <tr>
	    <td class='line' width='40%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            
                <%for (int i = 0 ; i < total_size ; i++){
    				StatTotalBean bean = (StatTotalBean)totals.elementAt(i);
    			
    				if (i == 0) {
    					b_nm = bean.getDept_nm();
    					b_cnt =0 ;
    					
    				}
    				    		   		         		
  				if (!b_nm.equals( bean.getDept_nm() )) {
  				     
           	%> 			
  				<tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;평균 평점</td>
               
                </tr>
              	<% 
					 b_nm = bean.getDept_nm();
					 b_cnt  =0;			 
			 	
		   		}    
		   		
		   		b_cnt += 1;          	
   			%>  
                <tr> 
                    <td align="center" width="25%" height="20"><%=bean.getDept_nm()%></td>
                    <td align="center" width="10%" height="20"><%= b_cnt%></td>
                    <td align="center" width="30%" height="20"><%=bean.getUser_nm()%></font></a></td>
                    <td align="center" width="35%" height="20"><%=AddUtil.ChangeDate2(bean.getEnter_dt())%>  </td>
             
                </tr>
         <% } %> 
  	       <tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;평균 평점</td>                 
                </tr>
		    
                <tr> 
                    <td class=title_p align="center" colspan="4" height="20">평균 평점</td>                
                </tr>
            </table>
        </td>  
           
              <td class='line' width='60%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for (int i = 0 ; i < total_size ; i++){
				StatTotalBean bean = (StatTotalBean)totals.elementAt(i);
				
				htot_ga[1]  += bean.getMng_ga() +   bean.getDly_ga() ; //평점
				hm_ga[1] 	+= bean.getMng_ga();  //관리
				hd_ga[1] 	+= bean.getDly_ga(); //연체
				hb_ga[1] 	+= bean.getBus_ga() ; // 영업
				hd_per[1] 	+= bean.getDly_per(); //연체율
				
				if (i == 0) {
    					b_nm = bean.getDept_nm();
    					b_cnt =0 ;    					
    				}
							
				 if (b_nm.equals(bean.getDept_nm()  )) {    		
					htot_ga[0]  += bean.getMng_ga() +   bean.getDly_ga() ; //평점
					hm_ga[0] 	+= bean.getMng_ga();  //관리
					hd_ga[0] 	+= bean.getDly_ga(); //연체
					hb_ga[0] 	+= bean.getBus_ga() ; // 영업
					hd_per[0] 	+= bean.getDly_per(); //연체율
				}
				
				
				 if (!b_nm.equals(bean.getDept_nm()  )) {
			       
		%>			
				
                <tr>
                  <td class=title align="center" width="20%"><%=AddUtil.parseFloatCipher2(htot_ga[0]/b_cnt,2)%></td> 
                  <td class=title align="center" width="20%"><%=AddUtil.parseFloatCipher2(hm_ga[0]/b_cnt,2)%></td> 
                  <td class=title  align="center" width="20%"><%=AddUtil.parseFloatCipher2(hd_ga[0]/b_cnt,2)%></td> 
                  <td class=title align="center" width="20%"><%=AddUtil.parseFloatCipher2(hd_per[0]/b_cnt,2)%></td> 
                  <td class=title align="center" width="20%"><%=AddUtil.parseFloatCipher2(hb_ga[0]/b_cnt,2)%></td>               
                </tr>
                
                 <% 
				b_nm = bean.getDept_nm();
				 b_cnt  =0;
				
				 htot_ga[0] =0; 
				 hm_ga[0] = 0; 
				 hd_ga[0] = 0; 
				 hb_ga[0] = 0; 			
				 hd_per[0] = 0 ;
					 
				
				htot_ga[0] += bean.getMng_ga() +   bean.getDly_ga() ; //평점
				hm_ga[0] 	+= bean.getMng_ga();  //관리
				hd_ga[0] 	+= bean.getDly_ga(); //연체
				hb_ga[0] 	+= bean.getBus_ga() ; // 영업
				hd_per[0] += bean.getDly_per(); //연체율
				 
                		}
                	
                		b_cnt += 1;          	
                %>
              
                <tr> 
                	 <td  align="center" width="20%"><%=AddUtil.parseFloatCipher2(bean.getMng_ga()+bean.getDly_ga(),2)%></td> 
                    <td align="center"> <%=AddUtil.parseFloatCipher2(bean.getMng_ga(),2)%></td>
                    <td align="center"> <%=AddUtil.parseFloatCipher2(bean.getDly_ga(),2)%></td>
                    <td align="center"><%=AddUtil.parseFloatCipher2(bean.getDly_per(),2)%> %</td>
                    <td align="center"> <%=AddUtil.parseFloatCipher2(bean.getBus_ga(),2)%></td>
                </tr>
                <%}%>
              <tr>
                  <td class=title align="center" width="20%"><%=AddUtil.parseFloatCipher2(htot_ga[0]/b_cnt,2)%></td> 
                  <td  class=title align="center" width="20%"><%=AddUtil.parseFloatCipher2(hm_ga[0]/b_cnt,2)%></td> 
                  <td class=title align="center" width="20%"><%=AddUtil.parseFloatCipher2(hd_ga[0]/b_cnt,2)%></td> 
                  <td class=title align="center" width="20%"><%=AddUtil.parseFloatCipher2(hd_per[0]/b_cnt,2)%></td> 
                  <td class=title  align="center" width="20%"><%=AddUtil.parseFloatCipher2(hb_ga[0]/b_cnt,2)%></td>               
                </tr>
                
                   <tr>
                  <td class=title_p align="center" width="20%"><%=AddUtil.parseFloatCipher2(htot_ga[1]/total_size,2)%></td> 
                  <td  class=title_p align="center" width="20%"><%=AddUtil.parseFloatCipher2(hm_ga[1]/total_size,2)%></td> 
                  <td  class=title_p  align="center" width="20%"><%=AddUtil.parseFloatCipher2(hd_ga[1]/total_size,2)%></td> 
                  <td  class=title_p align="center" width="20%"><%=AddUtil.parseFloatCipher2(hd_per[1]/total_size,2)%></td> 
                  <td  class=title_p  align="center" width="20%"><%=AddUtil.parseFloatCipher2(hb_ga[1]/total_size,2)%></td>               
                </tr>
        
            </table>
	    </td>
	</tr>
	
</table>		
</form>
<script language='javascript'>
<!--
//	set_sum();
	var fm = document.form1;	
	if(fm.save_dt.value == '' && fm.gubun_dt.value != '')			parent.document.form1.view_dt.value = '<%=AddUtil.ChangeDate2(gubun_dt)%>';
//	else if(fm.save_dt.value != '' && fm.gubun_dt.value != '')		parent.document.form1.view_dt.value = fm.save_dt.value;	
//-->
</script>
</body>
</html>
