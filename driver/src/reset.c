/******************************************************************************
*Copyright(C)2017, Xiaohua Semiconductor Co.,Ltd All rights reserved.
*
* This software is owned and published by:
* Xiaohua Semiconductor Co.,Ltd("XHSC").
*
* BY DOWNLOADING, INSTALLING OR USING THIS SOFTWARE, YOU AGREE TO BE BOUND
* BY ALL THE TERMS AND CONDITIONS OF THIS AGREEMENT.
*
* This software contains source code for use with XHSC
* components. This software is licensed by XHSC to be adapted only
* for use in systems utilizing XHSC components. XHSC shall not be
* responsible for misuse or illegal use of this software for devices not
* supported herein. XHSC is providing this software "AS IS" and will
* not be responsible for issues arising from incorrect user implementation
* of the software.
*
* Disclaimer:
* XHSC MAKES NO WARRANTY, EXPRESS OR IMPLIED, ARISING BY LAW OR OTHERWISE,
* REGARDING THE SOFTWARE (INCLUDING ANY ACOOMPANYING WRITTEN MATERIALS),
* ITS PERFORMANCE OR SUITABILITY FOR YOUR INTENDED USE, INCLUDING,
* WITHOUT LIMITATION, THE IMPLIED WARRANTY OF MERCHANTABILITY, THE IMPLIED
* WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE OR USE, AND THE IMPLIED
* WARRANTY OF NONINFRINGEMENT.
* XHSC SHALL HAVE NO LIABILITY (WHETHER IN CONTRACT, WARRANTY, TORT,
* NEGLIGENCE OR OTHERWISE) FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT
* LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION,
* LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING FROM USE OR
* INABILITY TO USE THE SOFTWARE, INCLUDING, WITHOUT LIMITATION, ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES OR LOSS OF DATA,
* SAVINGS OR PROFITS,
* EVEN IF Disclaimer HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
* YOU ASSUME ALL RESPONSIBILITIES FOR SELECTION OF THE SOFTWARE TO ACHIEVE YOUR
* INTENDED RESULTS, AND FOR THE INSTALLATION OF, USE OF, AND RESULTS OBTAINED
* FROM, THE SOFTWARE.
*
* This software may be replicated in part or whole for the licensed use,
* with the restriction that this Disclaimer and Copyright notice must be
* included with each copy of this software, whether used in part or whole,
* at all times.
*/

/** \file reset.c
 **
 ** Common API of reset.
 ** @link resetGroup Some description @endlink
 **
 **   - 2017-05-04
 **
 ******************************************************************************/

/*******************************************************************************
 * Include files
 ******************************************************************************/
#include "reset.h"

/**
 *******************************************************************************
 ** \addtogroup ResetGroup
 ******************************************************************************/
//@{

/*******************************************************************************
 * Local pre-processor symbols/macros ('#define')
 ******************************************************************************/


/*******************************************************************************
 * Global variable definitions (declared in header file with 'extern')
 ******************************************************************************/

/*******************************************************************************
 * Local type definitions ('typedef')
 ******************************************************************************/

/*******************************************************************************
 * Local variable definitions ('static')
 ******************************************************************************/

/*******************************************************************************
 * Local function prototypes ('static')
 ******************************************************************************/


/*******************************************************************************
 * Function implementation - global ('extern') and local ('static')
 ******************************************************************************/

/**
 *******************************************************************************
 ** \brief 获取复位源类型.
 **
 ** \param [out]  enRstFlg  @ref en_reset_flag_t     
 ** 
 ** \retval  TRUE or FALSE 
 ******************************************************************************/
boolean_t Reset_GetFlag(en_reset_flag_t enRstFlg)
{    
    if(M0P_RESET->RESET_FLAG&enRstFlg)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }     
}

/**
 *******************************************************************************
 ** \brief 清除复位源类型.
 **
 ** \param [in]  pstcFlag  @ref en_reset_flag_t
 ** 
 ** \retval  Null
 ******************************************************************************/
void Reset_ClearFlag(en_reset_flag_t enRstFlg)
{
    M0P_RESET->RESET_FLAG &= ~(uint32_t)enRstFlg;
}

/**
 *******************************************************************************
 ** \brief 清除所有复位源类型.
 **
 ** \param Null
 ** 
 ** \retval  Null
 ******************************************************************************/
void Reset_ClearFlagAll(void)
{
    M0P_RESET->RESET_FLAG = 0;
}

/**
 *******************************************************************************
 ** \brief 所有模块进行一次复位.
 **
 ** 
 ** \retval  Null
 ******************************************************************************/
void Reset_RstPeripheralAll(void)
{
    M0P_RESET->PERI_RESET = 0u;
    M0P_RESET->PERI_RESET = 0xFFFFFFFFu;     
}

/**
 *******************************************************************************
 ** \brief 对外设源模块进行一次复位.
 **
 ** \param [in]  enPeri  @ref en_reset_peripheral_t
 ** 
 ** \retval  Null
 ******************************************************************************/
void Reset_RstPeripheral(en_reset_peripheral_t enPeri)
{
    M0P_RESET->PERI_RESET &= ~(uint32_t)enPeri;
    M0P_RESET->PERI_RESET |= (uint32_t)enPeri;
}



//@} // ResetGroup

/*******************************************************************************
 * EOF (not truncated)
 ******************************************************************************/

