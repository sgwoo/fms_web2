<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*, acar.ext.*, acar.fee.*, acar.car_accident.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rtype = request.getParameter("rtype")==null?"":request.getParameter("rtype");
	String rent="";
	int total_su = 0;
	long total_amt = 0;	
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
		
	//해지정산 리스트
	Vector clss = ae_db.getClsFeeScdList(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, rtype);
	int cls_size = clss.size();
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<script type="text/javascript">
$('document').ready(function() {
	//div값 화면 셋팅값으로 초기화
	var frame_height = Number($("#height").val());
	//var frame_height = Number(document.body.offsetHeight);
	
	var form_width = Number($("#form1").width());
	var title_width = Number($("#td_title").width());	
	var title_height = Number($(".left_header_table").height());
	
	$(".left_contents_div").css("height", (frame_height - title_height)  );	
	$(".right_contents_div").css("height", (frame_height - title_height)  );
	/* $(".left_contents_div").css("height", frame_height - 100);	
	$(".right_contents_div").css("height", frame_height - 100); */
	
	$(".right_header_div").css("width", form_width - title_width);
	$(".right_contents_div").css("width", form_width - title_width);
		
	//브라우저 리사이즈시 width, height값 조정
	$(window).resize(function (){
		
		var frame_height = Number($("#height").val());
		//var frame_height = Number(document.body.offsetHeight);
		
		var form_width = Number($("#form1").width());
		var title_width = Number($("#td_title").width());		
		var title_height = Number($(".left_header_table").height());
		
		$(".left_contents_div").css("height", (frame_height - title_height) ) ;	
		$(".right_contents_div").css("height", (frame_height - title_height) );
		/* $(".left_contents_div").css("height", frame_height - 100);	
		$(".right_contents_div").css("height", frame_height - 100); */
		
		$(".right_header_div").css("width", form_width - title_width);
		$(".right_contents_div").css("width", form_width - title_width);		
	})

});
</script>
<script language='javascript'>
<!--	
	//레이아웃 스크롤 제어
	/* function fixDataOnWheel() {
		if (event.wheelDelta < 0) {
	        DataScroll.doScroll('scrollbarDown');
	    } else {
	        DataScroll.doScroll('scrollbarUp');
	    }d 
	    dataOnScroll();
	    dataOnScrollLeft();
	} */
	
	function dataOnScroll() {
	    left_contents.scrollTop = right_contents.scrollTop;
	    right_header.scrollLeft = right_contents.scrollLeft;
	}
		
	function dataOnScrollLeft() {
		
	//	if (event.wheelDelta < 0) {
	//        DataScroll.doScroll('scrollbarDown');
	//    } else {
	//        DataScroll.doScroll('scrollbarUp');
	//   } 
	    
	    right_contents.scrollTop = left_contents.scrollTop;
	    right_header.scrollLeft = right_contents.scrollLeft;
	}
	
 //-->   
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
.left_contents_div::-webkit-scrollbar {
    width: 0.1px;
    background: transparent;
}
.left_contents_div { 
	overflow-y: overlay !important;
}	
.right_contents_div {
	/* overflow-x: auto !important; */
}

/* html {scrollbar-3dLight-Color: #efefef; scrollbar-arrow-color: #dfdfdf; scrollbar-base-color: #efefef; scrollbar-Face-Color: #dfdfdf; scrollbar-Track-Color: #efefef; scrollbar-DarkShadow-Color: #efefef; scrollbar-Highlight-Color: #efefef; scrollbar-Shadow-Color: #efefef} */

/* Chrome, Safari용 스크롤 바 */
/* ::-webkit-scrollbar {width: 8px; height: 8px; border: 3px solid #fff; }
::-webkit-scrollbar-button:start:decrement, ::-webkit-scrollbar-button:end:increment {display: block; height: 10px; background: url('./images/bg.png') #efefef}
::-webkit-scrollbar-track {background: #efefef; -webkit-border-radius: 10px; border-radius:10px; -webkit-box-shadow: inset 0 0 4px rgba(0,0,0,.2)}
::-webkit-scrollbar-thumb {height: 50px; width: 50px; background: rgba(0,0,0,.2); -webkit-border-radius: 8px; border-radius: 8px; -webkit-box-shadow: inset 0 0 4px rgba(0,0,0,.1)} */
</style>

</head>
<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type='hidden' name='fee_size' value='<%=cls_size%>'>

<table border="0" cellspacing="0" cellpadding="0" width='1460'>
 <tr id='tr_title' style='position:relative; z-index:1'>
       <td class='' width='460' id='td_title' >  
        <div id="left_header" class="left_header_div" style="width:470px;">		      
	   	    <table class="left_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">
	            <tr> 
	              <td width='40' class='title'>연번</td>	
                    <td width='40' class='title'>채권</td>		
                    <td width='80' class='title'>구분</td>
        		    <td width='100' class='title'>계약번호</td>
        		    <td width='120' class='title'>상호</td>
        		    <td width='80' class=title>차량번호</td>	
	               </tr>
	           </table>
        </div>
        <div id="left_contents" class="left_contents_div" style="width: 470px;" onScroll="dataOnScrollLeft()"><!-- onmousewheel="fixDataOnWheel()" -->  
         <table class="left_contents_table"  border="0" cellspacing="1" cellpadding="0" width='100%'>
         
   <%	if(cls_size > 0){%>
     <%		for (int i = 0 ; i < cls_size ; i++){
			Hashtable cls = (Hashtable)clss.elementAt(i);
			//연체료 셋팅
			boolean flag = ae_db.calDelay((String)cls.get("RENT_MNG_ID"), (String)cls.get("RENT_L_CD"));%>
                <tr> 
                    <td width='40' align='center'>
				<!--	<a href="javascript:parent.view_memo3('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"> -->
						<%=i+1%>
					<!--	</a> --></td>
                    <td width='40' align='center'>
               
         				<a href="javascript:parent.view_memo('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>','9','<%=cls.get("CR_GUBUN")%>','','')" onMouseOver="window.status=''; return true"><%=cls.get("CR_GUBUN")%></a>
         			
        			</td>
                    <td width='80' align='center'>
                    <%if(String.valueOf(cls.get("CLS_GUBUN")).trim().equals("정산금")){%>
                    	<a href="javascript:parent.view_memo('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>','4','','','<%=cls.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title="<%=a_cad.getMaxMemo(String.valueOf(cls.get("RENT_MNG_ID")), String.valueOf(cls.get("RENT_L_CD")), "4", "", "")%>">
                    	<%if(String.valueOf(cls.get("CLS_ST")).trim().equals("14")){%>
                    	<font color='red'>(월)</font><%=cls.get("GUBUN")%>
                    	<%}else{%>
                    	<%=cls.get("GUBUN")%>
                    	<%}%>
                    	</a>
                    <%}else{%>
                   		<a href="javascript:parent.view_memo2('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','1','<%=cls.get("TM")%>','0','<%=cls.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title="<%=af_db.getMaxMemo(String.valueOf(cls.get("RENT_MNG_ID")), String.valueOf(cls.get("RENT_L_CD")), "")%>"><font color='red'><%=cls.get("GUBUN")%></font></a>
                    <%}%>            
                    </td>
                    <td width='100' align='center'><a href="javascript:parent.view_cls('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=cls.get("RENT_L_CD")%></a></td>
                    <td width='120' align='center'><span title='<%=cls.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(cls.get("FIRM_NM")), 7)%></a></span></td>
                    <td width=80 align='center'><span title='<%=cls.get("CAR_NO")%>'>
                      <%if(String.valueOf(cls.get("PREPARE")).equals("9") || String.valueOf(cls.get("PREPARE")).equals("4") ){%>
                  			  <font color="green"><%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%></font>
                     <% }  else { %>
                    		<%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%>
                     <%} %> 
                    </span></td>
                </tr>
          <%		}%>
                <tr> 
                    <td class="title" align='center'></td>
        			<td class="title" colspan=4 align='center'>합계</td>
                    <td class="title">&nbsp;</td>
                </tr>
       <%} else  {%>  
			   	<tr>
			        <td align='center'>등록된 데이타가 없습니다</td>
			    </tr>	              
		 <%}	%>
		     </table>
		  </div>		
		</td>
	    <td>			
		<div id="right_header" class="right_header_div custom_scroll">
		            <table class="right_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">   
	  
                <tr> 
                    <td width='150' class='title'>차명</td>
                    <td width='80' class='title'>해지일자</td>
                    <td width='60' class='title'>해지구분</td>			
                    <td width='80' class='title'>입금예정일</td>
                    <td width='50' class='title'>회차</td>
                    <td width='100' class='title'>금액</td>
                    <td width='80' class='title'>수금일자</td>
                    <td width='70' class='title'>연체일수</td>
                    <td width='90' class='title'>보증보험</td>
					<td width='90' class='title'>입금액</td>
					<td width='90' class='title'>입금일자</td>
                    <td width=60 class='title'>영업담당</td>
                </tr>
            </table>
	    </div>                                    
    	  <div id="right_contents" class="right_contents_div" onScroll="dataOnScroll()">
		    <table class="right_contents_table" border="0" cellspacing="1" cellpadding="0" width='100%'>           	
<%	if(cls_size > 0){%>
          <%		for (int i = 0 ; i < cls_size ; i++){
			 		Hashtable cls = (Hashtable)clss.elementAt(i);			%>
                <tr> 
                    <td width='150' align='center'>
                    	<%if(String.valueOf(cls.get("PREPARE")).equals("9") || String.valueOf(cls.get("PREPARE")).equals("4") ){%>
                    		<font color=red>(<%if(String.valueOf(cls.get("PREPARE")).equals("9")){%>미회수<%}else if(String.valueOf(cls.get("PREPARE")).equals("4")){%>말소<%}%>)</font>
                    		<span title='<%=cls.get("CAR_NM")%> <%=cls.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NM"))+" "+String.valueOf(cls.get("CAR_NAME")), 6)%></span>
                    	<%}else{%>
                    		<span title='<%=cls.get("CAR_NM")%> <%=cls.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NM"))+" "+String.valueOf(cls.get("CAR_NAME")), 9)%></span>
                    	<%}%>
                    </td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("CLS_DT")))%></td>
                    <td width='60' align='center'><%=cls.get("CLS_GUBUN")%></td>			
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("EST_DT")))%></td>
                    <td width='50' align='center'><%=cls.get("TM")%><%=cls.get("TM_ST")%></td>
                    <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("AMT")))%></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("PAY_DT")))%></td>
                    <td width='70' align='right'><%=cls.get("DLY_DAYS")%>일</td>
                    <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("GI_AMT")))%></td>		
					<td width='90' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("PAY_AMT2")))%></td>		
					<td width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("PAY_DT2")))%></td>
                    <td width='60' align='center'><%=c_db.getNameById(String.valueOf(cls.get("BUS_ID2")), "USER")%></td>
                </tr>
          <%
				total_su = total_su + 1;
				total_amt = total_amt + AddUtil.parseLong(String.valueOf(cls.get("AMT")));
		  		}%>		  
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		  
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		  
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			
                </tr>
<%} else  {%>  
		       <tr>
			        <td width="1000" colspan="12" align='center'>&nbsp;</td>
			   </tr>	              
   <%}	%>
	          </table>
	        </div>
	    </td>
    </tr>
</table>
</form>	            

</body>
</html>
