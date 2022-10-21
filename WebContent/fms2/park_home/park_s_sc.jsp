<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.parking.*, acar.user_mng.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String start_dt 	= request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&gubun="+gubun+"&gubun1="+gubun1+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&brid="+brid+"&sort_gubun="+sort_gubun+"&asc="+asc+
				   	"&sh_height="+height+"";
				   	
	Vector vt = new Vector();
	
	String reg_dt = Util.getDate();
	
	vt = pk_db.getParkRealList(br_id, gubun, gubun1, start_dt, end_dt,  s_cc,  s_year,  s_kd, brid, t_wd ,sort_gubun, asc);

	int vt_size = vt.size();	
	
	int pcnt1 = 0;
	int pcnt2 = 0;
	int pcnt3 = 0;
	int pcnt5 = 0;
	int pcnt6 = 0;
	int ptot = 0;
			   	
	int ycnt1 = 0;
	int ycnt2 = 0;
	
	int ytot = 0;
	
	int scnt1 = 0;
	int scnt2 = 0;
	int scnt3 = 0;
	int scnt4 = 0;
	int stot = 0;
	
	int ecnt1 = 0;
	int ecnt2 = 0;
	int ecnt3 = 0;
	int ecnt4 = 0;
	int etot = 0;
	
	int gcnt1 = 0;
	int gcnt2 = 0;
	int gtot = 0;
						   	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 

//차고지 차량 통계 링크	
	function move_list(gubun1){
		var fm = document.form1;
		fm.gubun1.value = gubun1;
		fm.action = 'park_s_in.jsp';
		fm.target = 'inner';
		fm.submit();
	}

function ParkInReg(){
		var SUBWIN="park_i.jsp";	
		window.open(SUBWIN, "ParkInReg", "left=10, top=20, width=1000, height=700, scrollbars=no");
}

	function ParkOutReg(){
		var SUBWIN="park_o.jsp";	
		window.open(SUBWIN, "ParkOutReg", "left=10, top=20, width=1000, height=750, scrollbars=no");
}
	
	
    //출고처리
	function ParkOutAction(){
		var fm = inner.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'pr'){
				if(ck.checked == true){
					cnt++;
					idnum = ck.value;
				}
			}
		}	
		if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
		if(cnt > 1 ){ alert("차량을 하나만 선택하세요 !"); return; }
	
		var SUBWIN="";	
    		window.open(SUBWIN, "asset_reg", "left=10, top=20, width=1000, height=650 scrollbars=no");
										
		fm.action = "park_o.jsp";
		fm.target="asset_reg";
		fm.submit();
	}
	
	function popup3(brid)
	{
		var fm = document.form1;	
			
		var SUBWIN="park_today_list.jsp<%=valus%>";
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
		
	}
	
	function search2(){
		var fm = document.form1;		
		fm.action = "park_frame2.jsp";
		fm.target='d_content';
		fm.submit();
	}
	function save2(){
		var fm = document.form1;	
		if(!confirm('마감 하시겠습니까?')){	
			return;	
		}
		fm.action = 'park_magam_save_a.jsp';						
		fm.target = 'i_no';
		fm.submit();	
	}
	
//-->
</script>
</head>

<body leftmargin="15">
<form name='form1' method='post'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	 <input type='hidden' name='gubun1' value='<%=gubun1%>'>
	 <input type='hidden' name='brid' value='<%=brid%>'>
	 <input type='hidden' name='br_id' value='<%=br_id%>'>
	 <input type='hidden' name='valus' value='<%=valus%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
	<% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		<%-- <td><%if(!user_id.equals("000177")){%> --%>
		<a href="javascript:ParkInReg();"><img src=/acar/images/center/button_reg_igcar.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
		
			<a href="javascript:ParkOutAction();"><img src=/acar/images/center/button_cgcr.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		<%-- <%}%>	 --%>
	<%}%>
					현재 : <%=reg_dt%>
			
			&nbsp;&nbsp;<!--<a href="javascript:popup3('<%=brid%>')">[리스트인쇄]</a> -->
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  
			<a href="javascript:save2();"><img src=/acar/images/center/button_dimg.gif border=0 align=absmiddle></a>
					&nbsp;※마감보기: 
			<select name="save_dt">
				<%		
				//관리현황
				Vector deb1s = pk_db.getParkMList("PARK_MAGAM", brid);
				int deb1_size = deb1s.size();
					
				if(deb1_size > 0){
					for(int i = 0 ; i < deb1_size ; i++){
						ParkBean sd = (ParkBean)deb1s.elementAt(i);
							save_dt = String.valueOf(sd.getSave_dt());
								
								%>		
				<option value="<%=sd.getSave_dt()%>"><%=sd.getSave_dt()%></option>		
				<%	}
					}%>
				</select>
		&nbsp;&nbsp;<a href="javascript:search2()"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>  
		
				</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="park_s_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=auto, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr> 
     <td width='100%'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차고지 차량 통계</span></td>
    </tr>


<%	if(vt_size > 0)	{ 			
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);

		if(ht.get("CAR_USE").equals("1")){
			ycnt1++;
		}else if(ht.get("CAR_USE").equals("2")){
			ycnt2++;
		}
		ytot = ycnt1 + ycnt2;
		
		if(ht.get("CAR_ST").equals("2")){
			gcnt1++;
		}else{
			gcnt2++;
		}
		gtot = gcnt1 + gcnt2;
		
		if(AddUtil.parseInt(String.valueOf(ht.get("TAKING_P"))) == 5 ){
			scnt1++;
		}else if(AddUtil.parseInt(String.valueOf(ht.get("TAKING_P"))) == 7 ){
			scnt2++;
		}else if(AddUtil.parseInt(String.valueOf(ht.get("TAKING_P"))) >= 9 ){
			scnt3++;
		}else{
			scnt4++;
		}
		stot = scnt1 + scnt2 + scnt3 + scnt4 ;
				
		if(ht.get("FUEL_KD").equals("휘발유") || ht.get("FUEL_KD").equals("휘발유(무연)")){
			ecnt1++;
		}else if(ht.get("FUEL_KD").equals("LPG")){
			ecnt3++;
		}else if(ht.get("FUEL_KD").equals("경유")){
			ecnt2++;
		}else if(ht.get("FUEL_KD").equals("휘발유+LPG겸용") || ht.get("FUEL_KD").equals("휘발유(무연)+LPG겸용")){
			ecnt4++;
		}
		etot = ecnt1+ecnt2+ecnt3+ecnt4;
		
		
		if(ht.get("PARK_NM").equals("목동") || ht.get("PARK_NM").equals("목동주차장") || ht.get("PARK_NM").equals("영남") || ht.get("PARK_NM").equals("영남주차장") || ht.get("PARK_NM").equals("명진공업") || ht.get("PARK_NM").equals("오토크린")){
			pcnt1++;
		}else if(ht.get("PARK_NM").equals("부산지점") || ht.get("PARK_NM").equals("부산") || ht.get("PARK_NM").equals("부산조양") || ht.get("PARK_NM").equals("부산부경")){
			pcnt2++;
		}else if(ht.get("PARK_NM").equals("대전") || ht.get("PARK_NM").equals("대전지점") || ht.get("PARK_NM").equals("대전현대") || ht.get("PARK_NM").equals("대전금호")){
			pcnt3++;
		}else if(ht.get("PARK_NM").equals("광주지점") || ht.get("PARK_NM").equals("상무현대")){
			pcnt5++;
		}else if(ht.get("PARK_NM").equals("대구지점")){
			pcnt6++;
		}
		ptot = pcnt1 + pcnt2 + pcnt3 + pcnt5 + pcnt6;
	}
}%> 

    
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td height="8" colspan="6" class='title'><div align="center">주차장구분</div></td>
				    <td height="8" colspan="3" class='title'><div align="center">용도별</div></td>
				    <td height="8" colspan="3" class='title'><div align="center">사용구분</div></td>
			        <td colspan="5" class='title'>승차정원</td>
			        <td colspan="5" class='title'>연료구분</td>
		        </tr>
				<tr>
				  <td class='title' width='89'><a href="javascript:move_list(13)">본사</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(14)">부산</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(15)">대전</a></td>
				  <td class='title' width='89'><a href="javascript:move_list(16)">광주</a></td>
				  <td class='title' width='89'><a href="javascript:move_list(17)">대구</a></td>
			      <td class='title' width='89'>소계</td>
				  <td class='title' width='89'><a href="javascript:move_list(1)">렌트</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(2)">리스</a></td>
			      <td class='title' width='89'>소계</td>
			      <td class='title' width='89'><a href="javascript:move_list(11)">예비차</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(12)">대여차</a></td>
			      <td class='title' width='89'>소계</td>
			      <td class='title' width='89'><a href="javascript:move_list(3)">5인</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(4)">7인</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(5)">9인이상</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(6)">기타</a></td>
			      <td class='title' width='89'>소계</td>
			      <td class='title' width='89'><a href="javascript:move_list(7)">가솔린</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(8)">경유</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(9)">LPG</a></td>
			      <td class='title' width='89'><a href="javascript:move_list(10)">LPG겸용</a></td>
			      <td class='title' width='89'>소계</td>
				</tr>
				<tr>
				  <td height="18" align='center'>&nbsp;<%=pcnt1%></td>
			      <td height="18" align='center'>&nbsp;<%=pcnt2%></td>
			      <td height="18" align='center'>&nbsp;<%=pcnt3%></td>
				  <td height="18" align='center'>&nbsp;<%=pcnt5%></td>
				  <td height="18" align='center'>&nbsp;<%=pcnt6%></td>
			      <td height="18" align='center'>&nbsp;<%=ptot%></td>					
				  <td height="18" align='center'>&nbsp;<%=ycnt1%></td>
			      <td height="18" align='center'>&nbsp;<%=ycnt2%></td>
			      <td height="18" align='center'>&nbsp;<%=ytot%></td>
			      <td height="18" align='center'>&nbsp;<%=gcnt1%></td>
			      <td height="18" align='center'>&nbsp;<%=gcnt2%></td>
			      <td height="18" align='center'>&nbsp;<%=gtot%></td>
			      <td height="18" align='center'>&nbsp;<%=scnt1%></td>
			      <td height="18" align='center'>&nbsp;<%=scnt2%></td>
			      <td height="18" align='center'>&nbsp;<%=scnt3%></td>
			      <td height="18" align='center'>&nbsp;<%=scnt4%></td>
			      <td height="18" align='center'>&nbsp;<%=stot%></td>
			      <td height="18" align='center'>&nbsp;<%=ecnt1%></td>
			      <td height="18" align='center'>&nbsp;<%=ecnt2%></td>
			      <td height="18" align='center'>&nbsp;<%=ecnt3%></td>
			      <td height="18" align='center'>&nbsp;<%=ecnt4%></td>
			      <td height="18" align='center'>&nbsp;<%=etot%></td>
			  </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='h'></td>
	</tr>
</table>
</table>
</form>
</body>
</html>
