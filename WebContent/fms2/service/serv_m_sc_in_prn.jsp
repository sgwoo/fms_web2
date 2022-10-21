<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cus0601.*" %>
<%@ page import="acar.util.*, acar.user_mng.*, acar.cus_reg.*"%>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");   //7:스피드메이트 10:타이어휠타운 , 9:애니카랜드 8:두꺼비카센타 
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
			
	int vid_size =  0;
			
	String vid[] 	= request.getParameterValues("ch_cd");
	String car_mng_id 	= "";
	String serv_id 	= "";

	String value[] = new String[2];
	String varnum="";
	String allvarnum="";
	
	String set_dt 	= request.getParameter("set_dt")==null?"":request.getParameter("set_dt");
	
	Vector vt = new Vector();
%>

<%

  if (!set_dt.equals("") ) {  	
  	 vt = cr_db.getServConfList("", s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, sort);
  } else { 
			vid_size = vid.length;
	
		// 일괄처리
			for(int i=0;i < vid_size;i++){
				
				StringTokenizer st = new StringTokenizer(vid[i],"/");
				int s=0;
				while(st.hasMoreTokens()){
					value[s] = st.nextToken();
					s++;
				}
				car_mng_id 		= value[0];
				serv_id		= value[1];
						
				varnum = car_mng_id + serv_id;
				
				if ( i == vid_size - 1) {
					allvarnum= allvarnum +  "'" +  varnum + "' " ;
				} else { 
					allvarnum= allvarnum +  "'" +  varnum + "' , " ;
				}
				
		   }
						
			vt = cr_db.getServConfList1(allvarnum);
	}
	
	
	int vt_size = vt.size();
		
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_sup = 0;
	long total_add = 0;
	long total_tot = 0;
	
	String off_id = ""; //협력업체 id 
	
	//업체 ven_code
	if ( s_kd.equals("11") ) { //본동자동차 
		off_id = "005392"; 
	} else if ( s_kd.equals("8") ) { //두꺼비카센타
		off_id = "000092"; 
	} else if ( s_kd.equals("10") ) { //타이어휠타운 
		off_id = "008634"; 
	} 
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
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
	
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
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
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>       
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/service/serv_m_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='off_id' value='<%=off_id%>'> 
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
      <td colspan="2" class=line2></td>
    </tr>  
	<tr >
	  <td class='line' >
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
		    <td width='5%' class='title' style='height:45'>연번</td>
			<td width='16%' class='title'>정비업체</td>	
        	<td width='8%' class='title'>정비일자</td>
		    <td width="8%" class='title'>담당자</td>					
			<td width="16%" class='title'>고객</td>
			<td width='10%' class='title'>차량번호</td>
			<td width='13%' class='title'>차명</td>	
			<td width='8%' class='title'>공급가</td>	
			<td width='8%' class='title'>부가세</td>					  			
			<td width='8%' class='title'>정비금액</td>					  
		  </tr>
		</table>
	  </td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			total_sup = AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
			total_add = AddUtil.parseLong(String.valueOf(ht.get("ADD_AMT")));
			total_tot = AddUtil.parseLong(String.valueOf(ht.get("REP_AMT")));
			
%>
				<tr>
					<td  width='5%' align='center'><%=i+1%></td>
					<td  width='16%' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 11)%></span></td>										
					<td  width='8%' align='center'><a href="javascript:parent.serv_action('<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("SERV_ID")%>', '<%=ht.get("ACCID_ID")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SERV_DT")))%></a></td>
					<td  width='8%' align='center'><%=ht.get("USER_NM")%></td>					
					<td  width='16%' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></td>					
					<td  width='10%' align='center'><%=ht.get("CAR_NO")%></td>
					<td  width='13%' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>					
					<td  width='8%' align='right'><%=AddUtil.parseDecimal(total_sup)%>&nbsp;</td>
					<td  width='8%' align='right'><%=AddUtil.parseDecimal(total_add)%>&nbsp;</td>
					<td  width='8%' align='right'><%=AddUtil.parseDecimal(total_tot)%>&nbsp;</td>

				</tr>
<%
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("ADD_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("REP_AMT")));
						
		}
%>
				<tr>
					<td class='title'>&nbsp;</td>				  				  				  				  
					<td class='title'>&nbsp;</td>				  				  				  				  
					<td class='title'>&nbsp;</td>				  				  				  				  
					<td class='title'>&nbsp;</td>				  				  				  				  
					<td class='title'>&nbsp;</td>				  				  				  
					<td class='title'>&nbsp;</td>				  				  				  				  
					<td class='title'>&nbsp;</td>
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%>&nbsp;</td>	
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt2)%>&nbsp;</td>	
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt3)%>&nbsp;</td>	

				</tr>
			</table>
		</td>
	 </tr>	

<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1370'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
	
</table>
</form>
</body>
</html>

