<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	
	int start_year 	= 2007;				//표시시작년도
	int end_year 	= AddUtil.getDate2(1);		//현재년도
 	int td_size 	= end_year-start_year+1;	//표시년도갯수
 	int td_width 	= 70/td_size;			//표시년도 사이즈 
	int car_ext_size= 8;				//지역갯수=서울,파주,포천,인천,부산,김해,대전,제주(광주)
	int car_kd_size	= 6;				//차종갯수=(렌트)승용,소형승합,중형승합 (리스)승용,승합,화물
	
	
	//총라인수=등록지역*차종구분
	int t_line = car_ext_size*car_kd_size;
	
	
	int y2000[] = new int[t_line];
	int y2001[] = new int[t_line];
	int y2002[] = new int[t_line];
	int y2003[] = new int[t_line];
	int y2004[] = new int[t_line];
	int y2005[] = new int[t_line];
	int y2006[] = new int[t_line];
	int y2007[] = new int[t_line];
	int y2008[] = new int[t_line];
	int y2009[] = new int[t_line];
	int y2010[] = new int[t_line];
	int y2011[] = new int[t_line];
	int y2012[] = new int[t_line];
	int y2013[] = new int[t_line];
	int y2014[] = new int[t_line];
	int y2015[] = new int[t_line];
	int y2016[] = new int[t_line];
	int y2017[] = new int[t_line];
	int y2018[] = new int[t_line];
	int y2019[] = new int[t_line];
	int y2020[] = new int[t_line];
	
	int idx = 0;


	Vector cars = ad_db.getStatCar(save_dt);
	int car_size = cars.size();
	
	for(int i = 0 ; i < car_size ; i++){
		StatCarBean bean = (StatCarBean)cars.elementAt(i);
		y2000[AddUtil.parseInt(bean.getSeq())] = bean.getY2000();
		y2001[AddUtil.parseInt(bean.getSeq())] = bean.getY2001();
		y2002[AddUtil.parseInt(bean.getSeq())] = bean.getY2002();
		y2003[AddUtil.parseInt(bean.getSeq())] = bean.getY2003();
		y2004[AddUtil.parseInt(bean.getSeq())] = bean.getY2004();
		y2005[AddUtil.parseInt(bean.getSeq())] = bean.getY2005();
		y2006[AddUtil.parseInt(bean.getSeq())] = bean.getY2006();
		y2007[AddUtil.parseInt(bean.getSeq())] = bean.getY2007();
		y2008[AddUtil.parseInt(bean.getSeq())] = bean.getY2008();
		y2009[AddUtil.parseInt(bean.getSeq())] = bean.getY2009();
		y2010[AddUtil.parseInt(bean.getSeq())] = bean.getY2010();
		y2011[AddUtil.parseInt(bean.getSeq())] = bean.getY2011();
		y2012[AddUtil.parseInt(bean.getSeq())] = bean.getY2012();
		y2013[AddUtil.parseInt(bean.getSeq())] = bean.getY2013();
		y2014[AddUtil.parseInt(bean.getSeq())] = bean.getY2014();
		y2015[AddUtil.parseInt(bean.getSeq())] = bean.getY2015();
		y2016[AddUtil.parseInt(bean.getSeq())] = bean.getY2016();
		y2017[AddUtil.parseInt(bean.getSeq())] = bean.getY2017();
		y2018[AddUtil.parseInt(bean.getSeq())] = bean.getY2018();
		y2019[AddUtil.parseInt(bean.getSeq())] = bean.getY2019();
		y2020[AddUtil.parseInt(bean.getSeq())] = bean.getY2020();
	}
	if(car_size < t_line){
		for(int i = car_size ; i < t_line ; i++){
			y2001[i] = 0;
			y2002[i] = 0;
			y2003[i] = 0;
			y2004[i] = 0;
			y2005[i] = 0;
			y2006[i] = 0;
			y2007[i] = 0;
			y2008[i] = 0;
			y2009[i] = 0;
			y2010[i] = 0;
			y2011[i] = 0;
			y2012[i] = 0;
			y2013[i] = 0;
			y2014[i] = 0;
			y2015[i] = 0;
			y2016[i] = 0;
			y2017[i] = 0;
			y2018[i] = 0;
			y2019[i] = 0;
			y2020[i] = 0;
		}
	}
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;	
		if(fm.save_dt.value != ''){ alert("이미 마감 등록된 자동차현황입니다."); return; }
		if(!confirm('마감하시겠습니까?'))
			return;
		fm.target='i_no';
		fm.submit();		
	}	

	//처음 셋팅하기
	function set_sum(){
		var p_fm = parent.document.form1;	
		var fm = document.form1;	
		var size = <%=t_line%>;
		var car_ext_size 	= <%=car_ext_size%>;
		var car_kd_size 	= <%=car_kd_size%>;		//소계포함
		
		//하단-합계
		for(i=0; i<car_kd_size ; i++){//6
			<%	for(int i = start_year ; i <= end_year ; i++){%>
					fm.y<%=i%>[i+size].value = parseDecimal(toInt(parseDigit(fm.y<%=i%>[i].value)) <%for(int j = 1 ; j < car_ext_size ; j++){//서울외지역%>+ toInt(parseDigit(fm.y<%=i%>[i+(car_kd_size*<%=j%>)].value))<%}%> );			
			<%	}%>
		}
		
		//세부 가로 합계	
		for(i=0; i<(car_ext_size+1)*car_kd_size; i++){//42
			fm.xhab[i].value = parseDecimal(<%for(int i = start_year ; i <= end_year ; i++){%>toInt(parseDigit(fm.y<%=i%>[i].value)) + <%}%> 0 );
		}		
		
		//용도별 소계
		var count = 0;
		for(i=0; i<(car_ext_size+1)*2; i++){//16
			<%	int thab_idx = 0;
			 	for(int i = start_year ; i <= end_year ; i++){
			  		thab_idx++;%>
					fm.yhab<%=thab_idx%>[i].value = parseDecimal(toInt(parseDigit(fm.y<%=i%>[i+count].value)) + toInt(parseDigit(fm.y<%=i%>[i+1+count].value)) + toInt(parseDigit(fm.y<%=i%>[i+2+count].value)));
			<%	}%>
			fm.xyhab[i].value = parseDecimal(toInt(parseDigit(fm.xhab[i+count].value))  + toInt(parseDigit(fm.xhab[i+1+count].value))  + toInt(parseDigit(fm.xhab[i+2+count].value)));						
			count += 2;				
		}

		
		//총계
		<%		thab_idx = 0;
				for(int i = start_year ; i <= end_year ; i++){
					thab_idx++;%>
		p_fm.thab<%=thab_idx%>.value = parseDecimal(toInt(parseDigit(fm.yhab<%=thab_idx%>[car_ext_size*2].value)) + toInt(parseDigit(fm.yhab<%=thab_idx%>[(car_ext_size*2)+1].value)));
		<%}%>
		p_fm.tothab.value = parseDecimal( <%for(int i = 1 ; i <= td_size ; i++){%>toInt(parseDigit(p_fm.thab<%=i%>.value)) + <%}%> 0);
	}	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form action="stat_car_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>		
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
    		  <!--서울--------------------------------------------------------->
                <tr> 
                    <td align="center" rowspan="8" width="4%">서울</td>
                    <td align="center" rowspan="4" width="8%">렌트사업용</td>
                    <td align="center" width="8%">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 0;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
        				if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center" width="<%=td_width%>%"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="5" class="whitenum"></td>
        			<%}%>
                    <td align="center" width="<%=100-20-(td_width*td_size)%>%"><input type="text" name="xhab" value="" size="5" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 1;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 2;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 3;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 4;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 5;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
    		    <!--파주--------------------------------------------------------->		  
                <tr> 
                    <td align="center" rowspan="8">파주</td>
                    <td align="center" rowspan="4">렌트사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 6;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 7;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 8;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 9;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 10;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 11;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"> <input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"> <input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
    		    <!--포천--------------------------------------------------------->		  
                <tr> 
                    <td align="center" rowspan="8">포천</td>
                    <td align="center" rowspan="4">렌트사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 30;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 31;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 32;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 33;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 34;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 35;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"> <input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"> <input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
    		    <!--인천--------------------------------------------------------->		  
                <tr> 
                    <td align="center" rowspan="8">인천</td>
                    <td align="center" rowspan="4">렌트사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 36;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 37;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 38;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 39;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 40;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 41;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"> <input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"> <input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>				
    		    <!--부산--------------------------------------------------------->		  
                <tr> 
                    <td align="center" rowspan="8">부산</td>
                    <td align="center" rowspan="4">렌트사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 12;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 13;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 14;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"> <input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 15;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 16;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 17;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
    		    <!--김해--------------------------------------------------------->		  
                <tr> 
                    <td align="center" rowspan="8">김해</td>
                    <td align="center" rowspan="4">렌트사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 18;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 19;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 20;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 21;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 22;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 23;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
    		    <!--대전--------------------------------------------------------->		  
                <tr> 
                    <td align="center" rowspan="8">대전</td>
                    <td align="center" rowspan="4">렌트사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 24;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 25;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 26;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 27;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 28;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 29;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
    		    <!--제주->광주--------------------------------------------------------->		  
                <tr> 
                    <td align="center" rowspan="8">광주</td>
                    <td align="center" rowspan="4">렌트사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 42;
        		//		if(i==2000) year_value = y2000[arr_idx];
        		//		if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        		//		if(i==2002) year_value = y2002[arr_idx];
        		//		if(i==2003) year_value = y2003[arr_idx];
        		//		if(i==2004) year_value = y2004[arr_idx];
        		//		if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 43;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 44;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 45;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 46;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){
        				int year_value =0;
        				int arr_idx = 47;
        			//	if(i==2000) year_value = y2000[arr_idx];
        			//	if(i==2001) year_value = y2001[arr_idx]+y2000[arr_idx];
        			//	if(i==2002) year_value = y2002[arr_idx];
        			//	if(i==2003) year_value = y2003[arr_idx];
        			//	if(i==2004) year_value = y2004[arr_idx];
        			//	if(i==2005) year_value = y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2006) year_value = y2006[arr_idx]+y2005[arr_idx]+y2004[arr_idx]+y2003[arr_idx]+y2002[arr_idx]+y2001[arr_idx]+y2000[arr_idx];
        				if(i==2007) year_value = y2007[arr_idx]+y2006[arr_idx];
        				if(i==2008) year_value = y2008[arr_idx];
					if(i==2009) year_value = y2009[arr_idx];
        				if(i==2010) year_value = y2010[arr_idx];
        				if(i==2011) year_value = y2011[arr_idx];
        				if(i==2012) year_value = y2012[arr_idx];
        				if(i==2013) year_value = y2013[arr_idx];
        				if(i==2014) year_value = y2014[arr_idx];
        				if(i==2015) year_value = y2015[arr_idx];
        				if(i==2016) year_value = y2016[arr_idx];
        				if(i==2017) year_value = y2017[arr_idx];
        				if(i==2018) year_value = y2018[arr_idx];
        				if(i==2019) year_value = y2019[arr_idx];
        				if(i==2020) year_value = y2020[arr_idx];
        				%>
                    <td align="center"><input type="text" name="y<%=i%>" value="<%=year_value%>" size="6" class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>			
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <!--합계--------------------------------------------------------->		                                  
                <tr> 
                    <td align="center" rowspan="8">합계</td>
                    <td align="center" rowspan="4">렌트사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){%>
                    <td align="center"><input type="text" name="y<%=i%>" size="6"  class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">소형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){%>
                    <td align="center"><input type="text" name="y<%=i%>" size="6"  class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">중형승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){%>
                    <td align="center"><input type="text" name="y<%=i%>" size="6"  class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4">리스사업용</td>
                    <td align="center">승용</td>
        			<%for(int i = start_year ; i <= end_year ; i++){%>
                    <td align="center"><input type="text" name="y<%=i%>" size="6"  class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">승합</td>
        			<%for(int i = start_year ; i <= end_year ; i++){%>
                    <td align="center"><input type="text" name="y<%=i%>" size="6"  class="whitenum"></td>
        			<%}%>
                    <td align="center""><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td align="center">화물</td>
        			<%for(int i = start_year ; i <= end_year ; i++){%>
                    <td align="center"><input type="text" name="y<%=i%>" size="6"  class="whitenum"></td>
        			<%}%>
                    <td align="center"><input type="text" name="xhab" size="6" class="whitenum"></td>
                </tr>
                <tr> 
                    <td class="is" align="center">소계</td>
        			<%for(int i = 1 ; i <= td_size ; i++){%>
                    <td class="is" align="center"><input type="text" name="yhab<%=i%>" size="6"  class="isnum"></td>
        			<%}%>
                    <td class="is" align="center"><input type="text" name="xyhab" size="6" class="isnum"></td>
                </tr>
            </table>
	    </td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
	set_sum();
//-->
</script>
</body>
</html>
