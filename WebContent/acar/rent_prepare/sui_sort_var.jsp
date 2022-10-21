<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = rs_db.getSuiSortVarList();
	int vt_size = vt.size();
	
	
	
	//보유차대수-업무대여제외
	int use_car_t_su = rs_db.getSuiSortVarCarCnt("","","","");
	
	int use_su 	= 0;
	int res_su 	= 0;
	int sui_su 	= 0;
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function var_update(mode, idx){
		var fm = document.form1;
		if(mode == 'i'){
			if(!confirm('등록하시겠습니까?'))	return;
		}else if(mode == 'u'){
			if(!confirm('수정하시겠습니까?'))	return;
		}
		fm.mode.value 	= mode;
		fm.idx.value 	= idx;
		fm.target='i_no';
		fm.action='sui_sort_var_a.jsp';
		fm.submit();		
	}			
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="size" value="<%=vt_size%>">
<input type="hidden" name="mode" value="">
<input type="hidden" name="idx" value="">

<table border=0 cellspacing=0 cellpadding=0 width="1050">
  <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 매각대상선별관리 > <span class=style5>선별기준변수</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class=line>                    
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td width="20" rowspan="2" class=title>연번</td>				
                    <td width="40" rowspan="2" class=title>코드</td>
                    <td colspan="3" class=title>차종</td>
                    <td width="50" class=title>기준1</td>
                    <td width="80" class=title>기준2</td>
                    <td colspan="4" class=title>기준3</td>
                    <td width="70" rowspan="2" class=title>기준일자</td>					
                    <td width="40" rowspan="2" class=title>처리</td>
                    <td colspan="4" class=title>차종비율</td>
                </tr>
                <tr>
                  <td width="175" class=title>구분</td>
                  <td width="80" class=title>소분류</td>
                  <td width="100" class=title>배기량</td>
                  <td width="50" class=title>차령</td>
                  <td width="85" class=title>주행거리</td>
                  <td width="60" class=title>경과일</td>
                  <td width="50" class=title>차령</td>
                  <td width="85" class=title>주행거리</td>
                  <td width="60" class=title>가동율</td>
				  <td width="45" class=title>보유</td>
				  <td width="45" class=title>예비</td>
				  <td width="45" class=title>선별</td>
				  
                </tr>
          		<%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					int res_car_su = rs_db.getSuiSortVarCarCnt("2", String.valueOf(ht.get("B_S_ST")),String.valueOf(ht.get("B_MIN_DPM")),String.valueOf(ht.get("B_MAX_DPM")));
					int use_car_su = rs_db.getSuiSortVarCarCnt("", String.valueOf(ht.get("B_S_ST")),String.valueOf(ht.get("B_MIN_DPM")),String.valueOf(ht.get("B_MAX_DPM")));
					use_su = use_su + use_car_su;
					res_su = res_su + res_car_su;
					sui_su = sui_su + AddUtil.parseInt(String.valueOf(ht.get("SORT_CNT")));
					%>
                <tr>                     
					<input type="hidden" name="seq" value="<%=ht.get("SEQ")%>">
					<td align=center><%=i+1%></td>					
					<td align=center><input type="text" name="sort_code" size="2" value="<%=ht.get("SORT_CODE")%>" class="whitetext" readonly></td>
                    <td align=center><textarea name="sort_gubun" cols="23" rows="2" class="whitetext"><%=ht.get("SORT_GUBUN")%></textarea>
					  <!--<%if(!String.valueOf(ht.get("SORT_GUBUN")).equals("")){%><br><font color='#666666'>(<%=ht.get("CARS")%>)</font><%}%>-->
					</td>
                    <td align=center><input type="text" name="b_s_st" size="10" class="text" value="<%=ht.get("B_S_ST")%>"></td>					
                    <td align=center><input type="text" name="b_min_dpm" size="3" class="num" value="<%=ht.get("B_MIN_DPM")%>">cc~<input type="text" name="b_max_dpm" size="3" class="num" value="<%=ht.get("B_MAX_DPM")%>">cc</td>
                    <td align=center><input type="text" name="b_mon_only" size="2" class="num" value="<%=ht.get("B_MON_ONLY")%>">개월</td>					
                    <td align=center><input type="text" name="b_dist_only" size="5" class="num" value="<%=ht.get("B_DIST_ONLY")%>">km이상</td>
                    <td align=center><input type="text" name="b_day" size="2" class="num" value="<%=ht.get("B_DAY")%>">일이상</td>										
                    <td align=center><input type="text" name="b_mon" size="2" class="num" value="<%=ht.get("B_MON")%>">개월</td>
                    <td align=center><input type="text" name="b_dist" size="5" class="num" value="<%=ht.get("B_DIST")%>">km이상</td>
                    <td align=center><input type="text" name="b_user_per" size="2" class="num" value="<%=ht.get("B_USE_PER")%>">%미만</td>
                    <td align=center><input type="text" name="reg_dt" size="8" class="text" value="<%=ht.get("REG_DT")%>"></td>															
                    <td align="center"> 
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:var_update('u', <%=i%>);"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a> 
					  <%		if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
					  &nbsp;
					  <a href="javascript:var_update('d', <%=i%>);">[D]</a> 
					  <%		}%>
                      <%	}%>
                    </td>
                    <td align=center><%=use_car_su%>대
					<%if(use_car_su>0){%>
					<br>(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(use_car_su))/AddUtil.parseFloat(String.valueOf(use_car_t_su))*100, 2)%>%)
					<%}%>								
					</td>	
					<td align=center><%=res_car_su%>대					
					<%if(res_car_su>0){%>
					<br>(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(res_car_su))/AddUtil.parseFloat(String.valueOf(use_car_su))*100, 2)%>%)
					<%}%>						
					</td>
					<td align=center><font color=green><%=ht.get("SORT_CNT")%>대</font>
					<%if(AddUtil.parseFloat(String.valueOf(ht.get("SORT_CNT")))>0){%>
					<br>(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("SORT_CNT")))/AddUtil.parseFloat(String.valueOf(res_car_su))*100, 2)%>%)
					<br>
					<%}%>											
					</td>
                </tr>
            	<%}%>
			    <tr>
			        <td class=h colspan="16"></td>
			    </tr>				
                <tr>                     
					<input type="hidden" name="seq" value="1">
					<td align=center>-</td>					
					<td align=center><input type="text" name="sort_code" size="2" value="" class="text"></td>
                    <td align=center><textarea name="sort_gubun" cols="23" rows="2" class="text"></textarea></td>
                    <td align=center><input type="text" name="b_s_st" size="10" class="text" value=""></td>					
                    <td align=center><input type="text" name="b_min_dpm" size="3" class="num" value="">cc~<input type="text" name="b_max_dpm" size="3" class="num" value="">cc</td>
                    <td align=center><input type="text" name="b_mon_only" size="2" class="num" value="">개월</td>					
                    <td align=center><input type="text" name="b_dist_only" size="5" class="num" value="">km이상</td>					
                    <td align=center><input type="text" name="b_day" size="2" class="num" value="">일이상</td>					
                    <td align=center><input type="text" name="b_mon" size="2" class="num" value="">개월</td>
                    <td align=center><input type="text" name="b_dist" size="5" class="num" value="">km이상</td>
                    <td align=center><input type="text" name="b_user_per" size="2" class="num" value="">%미만</td>
                    <td align=center><input type="text" name="reg_dt" size="8" class="text" value=""></td>															
                    <td align="center"> 
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:var_update('i', <%=vt_size%>);"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a> 
                      <%	}%>
                    </td>
                    <td align=center><%=use_su%><br><%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%><%=use_car_t_su%><%}%></td>
                    <td align=center><%=res_su%><br>(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(res_su))/AddUtil.parseFloat(String.valueOf(use_su))*100, 2)%>%)</td>
                    <td align=center><%=sui_su%><br>(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(sui_su))/AddUtil.parseFloat(String.valueOf(res_su))*100, 2)%>%)</td>															
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>    	
        <td align="right">
			<input type="checkbox" name="call_sp" value="Y" checked> 변수수정시 마감처리
			&nbsp;&nbsp;
			<a href="javascript:var_update('u', 999);" title='전체수정'><img src=../images/center/button_all_modify.gif border=0></a>
			&nbsp;&nbsp;
			<a href="javascript:self.close();"><img src=../images/center/button_close.gif border=0></a>
		</td>
    </tr>	
    <tr>
        <td>* 소분류 : <font color=red>100/101</font> 경승용, <font color=red>102</font> 소형승용, <font color=red>103</font> 중형승용, <font color=red>104/105/106</font> 대형승용, 
		               <font color=red>300</font> 소형승용LPG, <font color=red>301</font> 중형승용LPG, <font color=red>302</font> 대형승용LPG,<br>
			           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					   <font color=red>401/402</font> 5인승짚, <font color=red>501/502</font> 7~8인승, <font color=red>601/602</font> 9~10인승, <font color=red>701/702</font> 승합, 
					   <font color=red>801/802/803/811/821</font> 화물, <font color=red>901/902/903/904</font> 수입
		</td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>