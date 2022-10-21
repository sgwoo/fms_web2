<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.tire.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tire.TireDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<% 
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	String tire_gubun = request.getParameter("tire_gubun")==null?"":request.getParameter("tire_gubun");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

		int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-200;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"&tire_gubun="+tire_gubun+"";

	String title ="";
	if(tire_gubun.equals("000256")){
		title="타이어휠타운";
		from_page="n_tire_reg_off_frame.jsp";
	}
	if(tire_gubun.equals("000148")){
		title="두꺼비카센타";
		from_page="tire_reg_off_frame.jsp";
	}
	if(tire_gubun.equals("000156")){
		title="티스테이션시청점";
		from_page="ts_tire_reg_off_frame.jsp";
	}
	
	int count =0;
	int tire_count=0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = t_db.getDtireRegOffList(tire_gubun,s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
	
	long total_amt = 0;
	
	String serv_id = "";
%>

<html>
<head><title>FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=IE9">

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
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}	
			}
		}
		return;
	}
	
	function dtire_yn(seq, car_mng_id, rent_l_cd){
		var fm = document.form1;		

		if(!confirm('타이어휠타운에서 입력한 정비내역이 등록되어 있는 것을 확인하셨습니까?')){	return; }		
		if(!confirm('진짜로 정비내역을 확인하셨습니까?')){	return; }
		fm.cmd.value = 'YN';
		fm.seq.value = seq;
		fm.c_id.value = car_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.target = "i_no";
		fm.action = "tire_reg_off_iu_a.jsp";
		fm.submit();	
	}
	
	 //출력
	function select_print(){
		
		var width 	= 1024;		
		var height 	= screen.height;		
		window.open("tire_maint_list_print.jsp<%=valus%>", "Print", "left=0, top=0, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");				
	}
	 
	 
	
	function dtire_d(seq, car_mng_id, rent_l_cd){
		var fm = document.form1;			
		if(!confirm('등록 확인내역을 취소하시겠습니까?')){	return; }		
		fm.cmd.value = 'D';
		fm.seq.value = seq;
		fm.c_id.value = car_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.target = "i_no";
		fm.action = "tire_reg_off_iu_a.jsp";
		fm.submit();	
	}
	
	//확인메세지 전송
	function conf_sms_tint(){
		var fm = document.form1;			
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("확인요청을 보낼 정비를 선택하세요.");
			return;
		}	
		if(!confirm('확인요청 메세지를 발송하시겠습니까?')){	return; 		
		
		}
		fm.target = "i_no";
		//fm.target = "_blank";
		fm.action = "tire_sms_a.jsp";
		fm.submit();	
				
		
		
	}
	
	function updateSet(){	
	  var fm = document.form1;			
				
		if(fm.set_dt.value == ''){
		 	alert("정산일자를  입력하세요.");
			return;
		}
		
		if(confirm('처리하시겠습니까?')){		
			fm.target = "i_no";		
			fm.action = "serv_set_a.jsp<%=valus%>";
			fm.submit();	
		}		
		
}	


//-->
</script>


</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body topmargin=0>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='seq' 		value=''>
  <input type='hidden' name='c_id' 		value=''>
  <input type='hidden' name='rent_l_cd' 		value=''>
  <input type='hidden' name='cmd' 		value=''>
   <input type='hidden' name='tire_gubun' 		value='<%=tire_gubun%>'>
 <input type='hidden' name='from_page' 		value='<%=from_page%>'>  
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
  		<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='<%=vt_size%>' size='4' class=whitenum> 건</span>
	  <a href="javascript:select_print();"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a>
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) || (nm_db.getWorkAuthUser("전산팀",user_id)) || (nm_db.getWorkAuthUser("탁송관리자",user_id))){%>   
	  <a href="javascript:conf_sms_tint();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_sms_conf.gif" align="absmiddle" border="0"></a>&nbsp;
	  &nbsp;
	  <!--
    <span class=style2>정산일자</span>&nbsp;<input type='text' name="set_dt"  size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '> &nbsp;&nbsp;&nbsp; 
	 <a href="javascript:updateSet()"> [정산]</a> -->
	<%} %>     
	
	  </td>
	  <td align="right">
	  </td>
	</tr>
  	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='100%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='4%' class='title'>연번</td>
				  <td width='4%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		          <td width='6%' class='title'>등록여부</td>					
				  <td width='11%' class='title'>담당자확인</td>
				  <td width='8%' class='title'>정비구분</td>
		          <td width='7%' class='title'>정비일자</td>														  
				  <td width='7%' class='title'>담당자</td>
				  <td width='8%' class='title'>차량번호</td>
				  <td width='10%' class='title'>차명</td>
				  <td width='15%' class='title'>상호</td>					
				  <td width='7%' class='title'>금액</td>
				  <td width='4%' class='title'>수량</td>
				  <td width='20%' class='title'>내용</td>					
				</tr>
			  </tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("DTIRE_AMT")));
			String off_id_gubun="";
			if(tire_gubun.equals("000256")){
				off_id_gubun= "008634";
			}
			else if(tire_gubun.equals("000148")){
				off_id_gubun="000092";
			}
			else if(tire_gubun.equals("000156")){
				off_id_gubun="006470";
			}
			Hashtable ht3 = t_db.fine_serviceYN(String.valueOf(ht.get("CAR_MNG_ID")), off_id_gubun, String.valueOf(ht.get("DTIRE_DT")));
			serv_id = String.valueOf(ht3.get("SERV_ID"));
			tire_count+=AddUtil.parseInt(ht.get("DTIRE_ITEM_SU1")+"");
			%>
			
				<tr>
					<td  width='4%' align='center'><%=i+1%></td>
					<td  width='4%' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("SEQ")%>"></td>
					<td  width='6%' align='center'>
						<a href="javascript:parent.reg_cons('<%=ht.get("SEQ")%>','<%=ht.get("CAR_MNG_ID")%>', '<%if(ht.get("DTIRE_GB").equals("2")){%>2<%}else{%>1<%}%>','<%=ht.get("DTIRE_CARNO")%>')" onMouseOver="window.status=''; return true" >
							<img src="/acar/images/center/button_in_search.gif" align="absbottom" border="0">
						</a>
					</td>					
					<td  width='11%' align='center'><%if(!(ht.get("S_CNT")+"").equals("0")){%><a href="javascript:parent.view_tire('<%=ht.get("SEQ")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("DTIRE_YN")%>','RN')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_conf.gif" align="absbottom" border="0"></a><%}else{%><a href="javascript:parent.view_tire('<%=ht.get("SEQ")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("DTIRE_YN")%>','RN')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_nconf.gif" align="absbottom" border="0"></a><%}%><%//}%></td>					
					<td  width='8%' align='center'><%=ht.get("GUBUN")%></td>
					<td  width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DTIRE_DT")))%></td>					
					<td  width='7%' align='center'><%=ht.get("REQ_NM2")%></td>					
					<td  width='8%' align='center'><%=ht.get("DTIRE_CARNO")%></td>									
					<td  width='10%' align='center'>&nbsp;<%=ht.get("DTIRE_CARNM")%></td>
					<td  width='15%' align='center'>&nbsp;<%=ht.get("FIRM_NM")%></td>
					<td  width='7%' align='right'>&nbsp;<%=AddUtil.parseDecimal(ht.get("DTIRE_AMT"))%>&nbsp;</td>
					<td  width='4%' align='center'><%=ht.get("DTIRE_ITEM_SU1")%></td>
					<td  width='20%'>&nbsp;
					<%if(!ht.get("DTIRE_ITEM1").equals("")){%><%=ht.get("DTIRE_ITEM1")%><%}%>
					
					<%if(!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM1").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM2")%>
					<%}else if(!ht.get("DTIRE_ITEM1").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM3").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM2")%>,&nbsp;
					<%}else{%>
						<%=ht.get("DTIRE_ITEM2")%>
					<%}%>
					
					<%if(!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM1").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM3")%>
					<%}else if(!ht.get("DTIRE_ITEM1").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM4").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM3")%>,&nbsp;
					<%}else{%>
						<%=ht.get("DTIRE_ITEM3")%>
					<%}%>
					
					<%if(!ht.get("DTIRE_ITEM4").equals("")&&!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM1").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM4")%>
					<%}else if(!ht.get("DTIRE_ITEM1").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM4").equals("")&&!ht.get("DTIRE_ITEM5").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM4")%>,&nbsp;
					<%}else{%>
						<%=ht.get("DTIRE_ITEM4")%>
					<%}%>
					
					<%if(!ht.get("DTIRE_ITEM5").equals("")&&!ht.get("DTIRE_ITEM4").equals("")&&!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM1").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM5")%>
					<%}else if(!ht.get("DTIRE_ITEM1").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM4").equals("")&&!ht.get("DTIRE_ITEM5").equals("")&&!ht.get("DTIRE_ITEM6").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM5")%>,&nbsp;
					<%}else{%>
						<%=ht.get("DTIRE_ITEM5")%>
					<%}%>
					
					<%if(!ht.get("DTIRE_ITEM6").equals("")&&!ht.get("DTIRE_ITEM5").equals("")&&!ht.get("DTIRE_ITEM4").equals("")&&!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM1").equals("")){%>
						,&nbsp;<%=ht.get("DTIRE_ITEM6")%>
					<%}else{%>
						<%=ht.get("DTIRE_ITEM6")%>
					<%}%>
					
					</td>
				</tr>
<%		}%>
				<tr>				  				  
					<td align='center' colspan=3 class='title'>합계</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>			 
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td class="title" colspan=2 style='text-align:right'><%=Util.parseDecimal(total_amt)%> 원&nbsp;</td>					
					<td class="title" colspan=2 align='center'>총 <%=tire_count%>개</td>
					
				</tr>
			</table>
		</td>
	</tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
