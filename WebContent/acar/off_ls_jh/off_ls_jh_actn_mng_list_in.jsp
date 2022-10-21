<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_actn.*"%>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	//차량정보
	olaBean = olaD.getActn_detail(car_mng_id);
	
	//출품리스트
	Offls_auctionBean[] auctions = olaD.getAuction_list(car_mng_id);
	
	//System.out.println("car="+car_mng_id);
	//System.out.println(auctions.length);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	}
	
	function init(){		
		setupEvents();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/action/"+theURL;
		window.open(theURL,winName,features);
	}
-->
</script>
</head>
<body  onLoad="javascript:init()" >
<form name="form1" action="" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%">
                <tr> 
                    <td class='title' width=5% rowspan="2">연번</td>
                    <td class='title' width=10% rowspan="2">경매회차</td>
                    <td class='title' width=12% rowspan="2">경매상태</td>
                    <td class='title' width=13% rowspan="2">출품번호</td>
                    <td class='title' width=10% rowspan="2">경매일</td>
                    <td class='title' colspan="2">차량번호</td>
					
					<td class='title' rowspan="2" width=10%>출품수수료</td>
                    
					<td class='title' rowspan="2" width=10%>최종상태</td>
                    <td class='title' rowspan="2" width=10%>경매장</td>
                </tr>
                <tr> 
                    <td class='title' width=10%>변경전</td>
                    <td class='title' width=10%>변경후</td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%" >
            <%	if(auctions.length>0){
			for(int i=auctions.length-1; i>=0; i--){
				Offls_auctionBean auction = auctions[i];
	    %>
                <tr> 
                    <td align="center" width=5%><%=i+1%></td>
                    <td align="center" width=10%><%if(auction.getActn_cnt().equals("")){ out.println("-");}else{ out.println(auction.getActn_cnt()+"회");}%></td>
                    <td align="center" width=12%>
                      <a href="javascript:parent.view_detail('<%=auction.getSeq()%>')"> 
                        <%if(auction.getActn_st().equals("0")){%>
                        출품예정 
                        <%}else if(auction.getActn_st().equals("1")){%>
                        경매진행중 
                        <%}else if(auction.getActn_st().equals("2")){%>
                        유찰 
                        <%}else if(auction.getActn_st().equals("3")){%>
                        개별상담 
                        <%}else if(auction.getActn_st().equals("4")){%>
                        낙찰 
                        <%}%>
                      </a>
                    </td>
                    <td align="center" width=13%><%=auction.getActn_num()%> </td>
                    <td align="center" width=10%><%=AddUtil.ChangeDate2(auction.getActn_dt())%></td>
                    <%if(!auction.getActn_dt().equals("")){
        			int actn_dt = AddUtil.parseInt(auction.getActn_dt());
        			if(actn_dt>=AddUtil.parseInt(olaBean.getCha_dt())){%>
                    			<td align="center" width=10%> <%=olaBean.getCar_pre_no()%> </td>
                    			<td align="center" width=10%> <%=olaBean.getCar_no()%> </td>
                    <%		}else{%>
                    			<td align="center" width=10%> <%=olaBean.getCar_pre_no()%> </td>
                    			<td align="center" width=10%> <%=olaBean.getCar_pre_no()%> </td>
                    <%		}%>
        	    <%}else{%>
                    <td align="center"width=10%></td>
                    <td align="center"width=10%></td>
		    <%}%>
		    <td align="center"width=10%> 
			<%if(olaD.getActn_nm(olaBean.getActn_id()).equals("현대글로비스(주)")){%>
		      <%if(!auction.getOffls_file().equals("")){%>
			<a href="javascript:MM_openBrWindow('<%=auction.getOffls_file()%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><%=AddUtil.parseDecimal(auction.getOut_amt())%>원</a>
		      <%}else{%>
			<%=AddUtil.parseDecimal(auction.getOut_amt())%>원
		      <%}%>
			 <%}%>
		    </td>
                    <td align="center" width=10%>
                      <%if(auction.getChoi_st().equals("1")){%>
                      재출품 
                      <%}else if(auction.getChoi_st().equals("2")){%>
                      반출 
                      <%}%>
                    </td>
                    <td align="center" width=10%>
        	      <span title='<%=olaD.getActn_nm(olaBean.getActn_id())%>'><%=AddUtil.subData(olaD.getActn_nm(olaBean.getActn_id()),8)%></span></td>
                </tr>
            <%		}
		}else{%>
                <tr> 
                    <td  align="center" colspan="9">이력이 없습니다. </td>
                </tr>
            <%	}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
