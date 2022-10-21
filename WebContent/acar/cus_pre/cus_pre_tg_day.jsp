






<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.target = 'd_content';
		fm.action = 'cus0400_main.jsp';		
		fm.submit();	
	}

	//디스플레이 타입
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){
			td_br_id.style.display = '';
			td_mng_id.style.display = 'none';
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){
			td_br_id.style.display = 'none';
			td_mng_id.style.display = '';
		}else{
			td_br_id.style.display = 'none';
			td_mng_id.style.display = 'none';
		}
		//search();
	}
	
	//수금 스케줄 리스트 이동
	function list_move(gubun1, gubun2, gubun3)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = gubun1;
		fm.gubun2.value = gubun2;
		fm.gubun3.value = gubun3;
		
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){		//영업소
			fm.t_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){	//영업담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;			
		}else{
			fm.t_wd.value = '';					
		}
		
		var idx = gubun1;
		if(idx == '21') 	  url = "/acar/cus0401/cus0401_s_frame.jsp";
		else if(idx == '22') url = "/acar/cus0402/cus0402_s_frame.jsp";
		else if(idx == '23') url = "/acar/cus0403/cus0403_s_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
-->
</script>
</head>

<body>
<form name='form1' method='post' action='cus0400_main.jsp'>
  <table width="800" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="800" height="20" colspan="2" class=line> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="330">&lt; 관리현황 &gt;</td>
            <td width="10" rowspan="5">&nbsp;</td>
            <td width="460">&lt; 당일 업무추진현황 &gt;</td>
          </tr>
          <tr> 
            <td class=line width="330"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td width="90" class='title' align="center">구분</td>
                  <td width="120" class='title' align="center">거래처</td>
                  <td width="120" class='title' align="center">자동차</td>
                </tr>
                <tr> 
                  <td class='title' align="center">단독관리</td>
                  <td align="center"> <a href="#">30건</a></td>
                  <td align="center"> <a href="#">30건</a></td>
                </tr>
                <tr> 
                  <td class='title' align="center">공동관리</td>
                  <td align="center"><a href="#">7건</a></td>
                  <td align="center"><a href="#">7건</a></td>
                </tr>
                <tr> 
                  <td class='title' align="center">합계</td>
                  <td align="center"><a href="#">37건</a></td>
                  <td align="center"><a href="#">37건</a></td>
                </tr>
              </table></td>
            <td class=line rowspan="4"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                  <td class=title>거래처방문</td>
                  <td class=title>자동차관리</td>
                </tr>
                <tr> 
                  <td> <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr> 
                        <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                          <br> <font size="1">100</font> </td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="20" valign="bottom" align="center"><a href="#">37건</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="100"><img src=../../images/menu_back2.gif width=30 height=100></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="19" valign="bottom" align="center"><a href="#">30건</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="81"><img src=../../images/menu_back.gif width=30 height=81></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="68" valign="bottom" align="center"><a href="#">12건</a></td>
                            </tr>
                            <tr> 
                              <td height="32" valign="bottom"><img src=../../images/result1.gif width=30 height=32></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">전체</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">예정</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">실시</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="center">&nbsp;</td>
                        <td colspan="7" align="center"><font color="#999900">실시율 
                          32.43%</font><br> <br></td>
                      </tr>
                    </table></td>
                  <td> <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr> 
                        <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                          <br> <font size="1">100</font> </td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="20" valign="bottom" align="center"><a href="#">37건</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="100"><img src=../../images/menu_back2.gif width=30 height=100></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="19" valign="bottom" align="center"><a href="#">30건</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="81"><img src=../../images/menu_back.gif width=30 height=81></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="68" valign="bottom" align="center"><a href="#">12건</a></td>
                            </tr>
                            <tr> 
                              <td height="32" valign="bottom"><img src=../../images/result1.gif width=30 height=32></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">전체</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">예정</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">실시</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="center">&nbsp;</td>
                        <td colspan="7" align="center"><font color="#999900">실시율 
                          32.43%</font><br> <br></td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td width="330">&nbsp;</td>
          </tr>
          <tr> 
            <td class=line width="330"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td width="90" class=title>구분</td>
                  <td width="80" class=title>일반식</td>
                  <td width="80" class=title>기본식/맞춤식</td>
                  <td class=title width="80">합계</td>
                </tr>
                <tr> 
                  <td class=title>리스</td>
                  <td align="center"><a href="#">8대</a></td>
                  <td align="center"><a href="#">8대</a></td>
                  <td align="center"><a href="#">19대</a></td>
                </tr>
                <tr> 
                  <td class=title>렌트</td>
                  <td align="center"><a href="#">44대</a></td>
                  <td align="center"><a href="#">0대</a></td>
                  <td align="center"><a href="#">43대</a></td>
                </tr>
                <tr> 
                  <td class=title>합계</td>
                  <td align="center"><a href="#">52대</a></td>
                  <td align="center"><a href="#">8대</a></td>
                  <td align="center"><a href="#">72대</a></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; 당일 업무현황 &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="30" rowspan="3">연번</td>
            <td class='title' align="center" width="80" rowspan="3">성명</td>
            <td rowspan="3" class='title' align="center" width="95">총실시율</td>
            <td class='title' align="center" colspan="3">거래처방문</td>
            <td class='title' align="center" colspan="5">자동차정비</td>
            <td class='title' align="center" colspan="3">정기/정밀검사</td>
            <td class='title' align="center" colspan="3">고객정비요청</td>
          </tr>
          <tr> 
            <td width="40" class='title' align="center" rowspan="2">예정</td>
            <td width="40" class='title' align="center" rowspan="2">실시</td>
            <td width="50" class='title' align="center" rowspan="2">실시율</td>
            <td width="40" class='title' align="center" rowspan="2">예정</td>
            <td class='title' align="center" colspan="3">실시(실시자)</td>
            <td width="50" class='title' align="center" rowspan="2">실시율</td>
            <td width="40" class='title' align="center" rowspan="2">예정</td>
            <td width="40" class='title' align="center" rowspan="2">실시</td>
            <td width="45" class='title' align="center" rowspan="2">실시율</td>
            <td width="40" class='title' align="center" rowspan="2">예정</td>
            <td width="40" class='title' align="center" rowspan="2">실시</td>
            <td width="50" class='title' align="center" rowspan="2">실시율</td>
          </tr>
          <tr> 
            <td width="40" class='title' align="center">본인</td>
            <td width="40" class='title' align="center">지원</td>
            <td width="40" class='title' align="center">고객</td>
          </tr>
          <tr> 
            <td align="center">1</td>
            <td align="center"><a href="stat_p.htm" target="_blank">이광희</a></td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">2</td>
            <td align="center">황수연</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">3</td>
            <td align="center">김광수</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">4</td>
            <td align="center">최준원</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">5</td>
            <td align="center">김헌태</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">6</td>
            <td align="center">김욱</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center" height="22">7</td>
            <td align="center" height="22">오성호</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
            <td align="right" height="22">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">8</td>
            <td align="center">강주원</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' align="center">&nbsp;</td>
            <td class='title' align="center">합계</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; 당일 계약변경현황 &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="100">신규계약개시</td>
            <td align="center" width="300">5건</td>
            <td class='title' align="center" width="100">계약만료도래</td>
            <td width="300" align="center">1건</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; 당일 배차/반차업무현황 &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="30" rowspan="2">연번</td>
            <td class='title' align="center" width="80" rowspan="2">성명</td>
            <td class='title' align="center" width="90" rowspan="2">합계</td>
            <td class='title' align="center" colspan="2">단기대여</td>
            <td class='title' align="center" colspan="2">보험대차</td>
            <td class='title' align="center" colspan="2">지연대차</td>
            <td class='title' align="center" colspan="2">정비대차</td>
            <td class='title' align="center" colspan="2">사고대차</td>
            <td class='title' align="center" colspan="2">차량정비</td>
          </tr>
          <tr> 
            <td width="50" class='title' align="center">배차</td>
            <td width="50" class='title' align="center">반차</td>
            <td width="50" class='title' align="center">배차</td>
            <td width="50" class='title' align="center">반차</td>
            <td width="50" class='title' align="center">배차</td>
            <td width="50" class='title' align="center">반차</td>
            <td width="50" class='title' align="center">배차</td>
            <td width="50" class='title' align="center">반차</td>
            <td width="50" class='title' align="center">배차</td>
            <td width="50" class='title' align="center">반차</td>
            <td width="50" class='title' align="center">배차</td>
            <td width="50" class='title' align="center">반차</td>
          </tr>
          <tr> 
            <td align="center">1</td>
            <td align="center">이광희</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">2</td>
            <td align="center">황수연</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">3</td>
            <td align="center">김광수</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">4</td>
            <td align="center">최준원</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">5</td>
            <td align="center">김헌태</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">6</td>
            <td align="center">김욱</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center" height="22">7</td>
            <td align="center" height="22">오성호</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">8</td>
            <td align="center">강주원</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' align="center">&nbsp;</td>
            <td class='title' align="center">합계</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
</body>
</html>
<script language="JavaScript">
	//cng_input()
</script>
